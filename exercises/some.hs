takeFinal :: Int -> [a] -> [a]
takeFinal n xs = drop (length xs - n) xs
