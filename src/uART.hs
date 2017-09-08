module UART where
--https://gist.github.com/thoughtpolice/75cbdbe741078eb8d11f185af482c415

type Byte = Unsigned 8

data TxState
  = TxIdle
  | TxStart   (Unsigned 8)
  | TxSending (Unsigned 8)
  | TxDone
  deriving (Eq, Show, Ord, Generic, NFData)

isSending :: Signal TxState -> Signal Bool
isSending = fmap (\x -> case x of TxSending _ -> True; _ -> False)
--isSending = fmap (\ case TxSending _ -> True; _ -> False)

uartTx :: Signal Bool
       -> Signal (Maybe Byte)
       -> Signal (Bit, Bool)
uartTx hold input = bundle (out, finished)
  where
    bits :: Signal (Unsigned 3)
    bits = regEn 0 (hold .&&. isSending state) (bits + 1)

    finished :: Signal Bool
    finished = state .==. pure TxDone .&&. hold

    state :: Signal TxState
    out   :: Signal Bit
    ( state, out )
           = unbundle
           $ registerMaybe (TxIdle, high)
           $ bundle (hold, input, state, bits)
          <&> \(en, byte, st, off) -> do
              guard en
              case (byte, st) of
                -- Idle case: either we do nothing, or we
                -- transition to the start phase and send
                -- a high signal.
                (Nothing, TxIdle) -> Nothing
                (Just b,  TxIdle) -> pure (TxStart b, low)
                -- Start phase: now send a low signal, and
                -- transition to the send phase.
                (_, TxStart b)
                  -> pure (TxSending b , lsb b)

                -- Sending phase
                (_, TxSending b) ->
                  let bs = b `shiftR` 1
                      result | off == 7  = (TxDone, high)
                             | otherwise = (TxSending bs, lsb bs)
                  in pure result

                -- Done phase
                (_, TxDone) -> pure (TxIdle, high)
