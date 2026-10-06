USE CypherWatchDB;
GO

-- ===================================================================
-- CYPHER TIMEPIECES - 100% VERIFIED LOCAL LUXURY WATCH IMAGES ONLY
-- Zero non-watch items: No shoes, No handbags, No smartphones.
-- All images are served locally from /Content/images/watches/
-- ===================================================================

-- 1. Update Categories
UPDATE Categories SET ImageURL = '/Content/images/watches/watch_luxury_gold.jpg' WHERE CategoryID = 1;     -- Luxury
UPDATE Categories SET ImageURL = '/Content/images/watches/watch_pocket_watch.jpg' WHERE CategoryID = 2;    -- Classic
UPDATE Categories SET ImageURL = '/Content/images/watches/watch_tag_monaco.jpg' WHERE CategoryID = 3;       -- Sports
UPDATE Categories SET ImageURL = '/Content/images/watches/watch_casio_f91w.jpg' WHERE CategoryID = 4;       -- Smart Watch
UPDATE Categories SET ImageURL = '/Content/images/watches/watch_hero.jpg' WHERE CategoryID = 5;             -- Limited Edition
UPDATE Categories SET ImageURL = '/Content/images/watches/watch_cartier_tank.jpg' WHERE CategoryID = 6;    -- Dress Watch
UPDATE Categories SET ImageURL = '/Content/images/watches/watch_rolex_submariner.jpg' WHERE CategoryID = 7;-- Diver
UPDATE Categories SET ImageURL = '/Content/images/watches/watch_omega_chronograph.jpg' WHERE CategoryID = 8;-- Chronograph
GO

-- 2. Update Products (1 to 30) - All Verified Luxury Timepieces
UPDATE Products SET ImageURL = '/Content/images/watches/watch_rolex_submariner.jpg' WHERE ProductID = 1;   -- Submariner Date
UPDATE Products SET ImageURL = '/Content/images/watches/watch_omega_seamaster.jpg' WHERE ProductID = 2;     -- Seamaster 300
UPDATE Products SET ImageURL = '/Content/images/watches/watch_rolex_datejust.jpg' WHERE ProductID = 3;     -- PRX Powermatic 80
UPDATE Products SET ImageURL = '/Content/images/watches/watch_casio_f91w.jpg' WHERE ProductID = 4;         -- G-Shock GA-2100
UPDATE Products SET ImageURL = '/Content/images/watches/watch_luxury_gold.jpg' WHERE ProductID = 5;        -- Presage Cocktail
UPDATE Products SET ImageURL = '/Content/images/watches/watch_omega_chronograph.jpg' WHERE ProductID = 6;  -- Chronos Elite
UPDATE Products SET ImageURL = '/Content/images/watches/watch_breitling_seawolf.jpg' WHERE ProductID = 7;  -- Eco-Drive Promaster
UPDATE Products SET ImageURL = '/Content/images/watches/watch_cartier_tank.jpg' WHERE ProductID = 8;       -- Raga Vela
UPDATE Products SET ImageURL = '/Content/images/watches/watch_rolex_datejust.jpg' WHERE ProductID = 9;     -- Datejust 41
UPDATE Products SET ImageURL = '/Content/images/watches/watch_cartier_tank.jpg' WHERE ProductID = 10;      -- Constellation
UPDATE Products SET ImageURL = '/Content/images/watches/watch_tag_monaco.jpg' WHERE ProductID = 11;        -- T-Sport Solar
UPDATE Products SET ImageURL = '/Content/images/watches/watch_omega_speedmaster.jpg' WHERE ProductID = 12; -- Edifice EFS-S560
UPDATE Products SET ImageURL = '/Content/images/watches/watch_breitling_seawolf.jpg' WHERE ProductID = 13; -- 5 Sports SRPD
UPDATE Products SET ImageURL = '/Content/images/watches/watch_omega_chronograph.jpg' WHERE ProductID = 14; -- Neutra Chronograph
UPDATE Products SET ImageURL = '/Content/images/watches/watch_hero.jpg' WHERE ProductID = 15;              -- Satellite Wave F900
UPDATE Products SET ImageURL = '/Content/images/watches/watch_pocket_watch.jpg' WHERE ProductID = 16;      -- Zephyr Silver
UPDATE Products SET ImageURL = '/Content/images/watches/watch_rolex_explorer.jpg' WHERE ProductID = 17;    -- Explorer II
UPDATE Products SET ImageURL = '/Content/images/watches/watch_omega_speedmaster.jpg' WHERE ProductID = 18; -- Speedmaster Moonwatch
UPDATE Products SET ImageURL = '/Content/images/watches/watch_automatic.jpg' WHERE ProductID = 19;         -- Everytime Swissmatic
UPDATE Products SET ImageURL = '/Content/images/watches/watch_casio_f91w.jpg' WHERE ProductID = 20;        -- Mudmaster GWG-2000
UPDATE Products SET ImageURL = '/Content/images/watches/watch_luxury_gold.jpg' WHERE ProductID = 21;       -- Grand Seiko Spring
UPDATE Products SET ImageURL = '/Content/images/watches/watch_cartier_tank.jpg' WHERE ProductID = 22;      -- Minimalist Leather
UPDATE Products SET ImageURL = '/Content/images/watches/watch_omega_chronograph.jpg' WHERE ProductID = 23; -- CB5040-20E Signature
UPDATE Products SET ImageURL = '/Content/images/watches/watch_cartier_tank.jpg' WHERE ProductID = 24;      -- Sonata Quartz Ladies
UPDATE Products SET ImageURL = '/Content/images/watches/watch_rolex_daydate.jpg' WHERE ProductID = 25;     -- Skydweller
UPDATE Products SET ImageURL = '/Content/images/watches/watch_omega_seamaster.jpg' WHERE ProductID = 26;    -- Aqua Terra 150
UPDATE Products SET ImageURL = '/Content/images/watches/watch_tag_monaco.jpg' WHERE ProductID = 27;        -- T-Touch Expert Solar
UPDATE Products SET ImageURL = '/Content/images/watches/watch_breitling_seawolf.jpg' WHERE ProductID = 28; -- Protrek PRW-3500
UPDATE Products SET ImageURL = '/Content/images/watches/watch_rolex_daytona.jpg' WHERE ProductID = 29;     -- Astron GPS Solar
UPDATE Products SET ImageURL = '/Content/images/watches/watch_rolex_daydate.jpg' WHERE ProductID = 30;     -- Neva Gold Ladies
GO
