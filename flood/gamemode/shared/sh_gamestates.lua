---------------
-- Game state enumerators/constants. Improves readability when setting and checking the game staee.

FLOOD_GS_WAIT  = 0 -- Waiting for players to join.
FLOOD_GS_BUILD = 1 -- Boat building phase.
FLOOD_GS_BOARD = 2 -- Everyone gets on their boats.
FLOOD_GS_FLOOD = 3 -- Flooding phase.
FLOOD_GS_FIGHT = 4 -- Fighting phase.
FLOOD_GS_RESET = 5 -- Reseting game and map.
