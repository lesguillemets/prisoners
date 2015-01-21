module Action where
data Action = Betray | Coop deriving (Eq, Show, Read)
shortShow :: Action -> String
shortShow Betray = "B"
shortShow Coop = "C"

type Result = Int
