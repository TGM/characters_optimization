-- START --

-- set temp table memory size to 4GB, adjust according to needs, hash tables are expensive but fast, you can use BTREE is you don't have enought RAM
SET @@max_heap_table_size=4294967296;

-- MySQL does not support variables for database names, so replace @AUTH and @CHARACTERS with your database names, if you find another way to do it, let me know.

/* FIND DUPLICATES */
/* SELECT item_guid, count(*) FROM guild_bank_item group by item_guid having count(*) >= 2
DELETE FROM guild_bank_item WHERE item_guid NOT IN (SELECT * FROM (SELECT MIN(n.item_guid) FROM guild_bank_item n GROUP BY n.item_guid) x) */

/* MISC FIXES */
-- ALTER TABLE `mail_items` ADD UNIQUE INDEX `idx_item_guid`(`item_guid`);

/* CLEANUP ACCOUNTS */
-- DELETE FROM `@AUTH`.`account` WHERE DATE_SUB(CURDATE(),INTERVAL 90 DAY) > last_login and vip <> 1;
-- DELETE FROM `@AUTH`.`account` WHERE DATE_SUB(CURDATE(),INTERVAL 90 DAY) > `last_login` and `vip` <> 1 and `id` not in (select `account` from @CHARACTERS.`characters` where level < 78);

DELETE FROM `characters` WHERE ( `account` ) NOT IN ( SELECT id FROM `@AUTH`.`account` );

-- CLEANUP CHARACTERS
DELETE FROM `account_data` WHERE ( `accountId` ) NOT IN ( SELECT id FROM `@AUTH`.`account` );
DELETE FROM `account_instance_times` WHERE ( `accountId` ) NOT IN ( SELECT id FROM `@AUTH`.`account` );
DELETE FROM `account_tutorial` WHERE ( `accountId` ) NOT IN ( SELECT id FROM `@AUTH`.`account` );

DELETE FROM `arena_team` WHERE captainGuid NOT IN (SELECT guid FROM `characters` );
DELETE FROM `arena_team_member` WHERE arenaTeamId NOT IN (SELECT arenaTeamId FROM `arena_team` );
DELETE FROM `arena_team_member` WHERE guid NOT IN (SELECT guid FROM `characters` );

DELETE FROM `auctionhouse` WHERE `itemowner` NOT IN ( SELECT guid FROM `characters` );

DELETE FROM `character_account_data` WHERE `guid` NOT IN (SELECT guid FROM `characters` );
DELETE FROM `character_achievement` WHERE `guid` NOT IN (SELECT guid FROM `characters` );
DELETE FROM `character_achievement_progress` WHERE `guid` NOT IN (SELECT guid FROM `characters` );
DELETE FROM `character_action` WHERE `guid` NOT IN ( SELECT guid FROM `characters`);
DELETE FROM `character_arena_stats` WHERE `guid` NOT IN ( SELECT guid FROM `characters`);
DELETE FROM `character_aura` WHERE `guid` NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_banned` WHERE `guid` NOT IN ( SELECT guid FROM `characters` );

DELETE FROM `character_battleground_data` WHERE guid NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_battleground_random` WHERE guid NOT IN ( SELECT guid FROM `characters` );

DELETE FROM `character_declinedname` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_equipmentsets` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_gifts` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_glyphs` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_homebind` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_instance` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_inventory` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_pet` WHERE ( `owner` ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_pet_declinedname` WHERE ( `owner` ) NOT IN ( SELECT guid FROM `characters` ); 
DELETE FROM `character_queststatus` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_queststatus_daily` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_queststatus_rewarded` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_queststatus_weekly` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_reputation` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_skills` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_social` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_social` WHERE ( friend ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_spell` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_spell_cooldown` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_stats` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `character_talent` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );

TRUNCATE TABLE `corpse`; -- Revive all dead characters

DELETE FROM `groups` WHERE leaderGuid NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `group_member` WHERE guid NOT IN ( SELECT guid FROM `groups` );
DELETE FROM `group_member` WHERE memberGuid NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `group_instance` WHERE guid NOT IN ( SELECT guid FROM `groups` );
-- TRUNCATE TABLE `instance_reset`; -- use only if you want to reschredule cooldowns
DELETE FROM creature_respawn WHERE instanceId > 0 AND instanceId NOT IN (SELECT instanceId FROM instance);
DELETE FROM gameobject_respawn WHERE instanceId > 0 AND instanceId NOT IN (SELECT instanceId FROM instance);

-- gm_tickets -- no change needed for now

DELETE FROM `guild` WHERE ( leaderguid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `guild_bank_eventlog` WHERE PlayerGuid NOT IN (SELECT guid FROM `characters` );
DELETE FROM `guild_bank_eventlog` WHERE ( guildid ) NOT IN ( SELECT guildid FROM `guild` );
DELETE FROM `guild_bank_item` WHERE ( guildid ) NOT IN ( SELECT guildid FROM `guild` );
DELETE FROM `guild_bank_right` WHERE ( guildid ) NOT IN ( SELECT guildid FROM `guild` );
DELETE FROM `guild_bank_tab` WHERE ( guildid ) NOT IN ( SELECT guildid FROM `guild` );
DELETE FROM `guild_eventlog` WHERE ( guildid ) NOT IN ( SELECT guildid FROM `guild` );
DELETE FROM `guild_member` WHERE ( guid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `guild_rank` WHERE ( guildid ) NOT IN ( SELECT guildid FROM `guild` );

DELETE FROM `item_instance` WHERE ( owner_guid ) NOT IN ( SELECT guid FROM `characters` ) and owner_guid <> 0;
DELETE FROM `item_refund_instance` WHERE ( player_guid ) NOT IN ( SELECT guid FROM `characters` );
TRUNCATE `item_soulbound_trade_data`;

TRUNCATE TABLE `lag_reports`;
TRUNCATE TABLE `lfg_data`;

DELETE FROM `mail` WHERE ( receiver ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `mail_items` WHERE ( mail_id ) NOT IN ( SELECT id FROM `mail` );

DELETE FROM `pet_aura` WHERE guid NOT IN ( SELECT id FROM character_pet );
DELETE FROM `pet_spell` WHERE guid NOT IN (SELECT id FROM `character_pet` );
DELETE FROM `pet_spell_cooldown` WHERE guid NOT IN (SELECT id FROM `character_pet` );

DELETE FROM `petition` WHERE (ownerguid ) NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `petition_sign` WHERE ownerguid NOT IN ( SELECT guid FROM `characters` );
DELETE FROM `petition_sign` WHERE playerguid NOT IN (SELECT guid FROM `characters` );
DELETE FROM `petition_sign` WHERE petitionguid NOT IN (SELECT `petitionguid` FROM `petition` );

/* CUSTOM TABLES */
/*DELETE FROM `character_raf` WHERE recruiter_id NOT IN ( SELECT guid FROM characters );
DELETE FROM `character_xp_rates` WHERE guid NOT IN ( SELECT guid FROM characters );
TRUNCATE players_reports_status;*/




/* CREATE TEMP TABLES */
DROP TABLE IF EXISTS `tmp_guid_table`;
CREATE TABLE `tmp_guid_table` (	
	`guid_new` INT(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`guid` INT(10) unsigned NOT NULL,
	INDEX USING HASH (guid_new),
	INDEX USING HASH (guid)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
INSERT INTO `tmp_guid_table` (guid) SELECT `guid` FROM `characters`;

DROP TABLE IF EXISTS `tmp_groups_table`;
CREATE TABLE `tmp_groups_table` (	
	`guid_new` INT(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`guid` INT(10) unsigned NOT NULL,
	INDEX USING HASH (guid_new),
	INDEX USING HASH (guid)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
INSERT INTO `tmp_groups_table` (guid) SELECT `guid` FROM `groups`;




/*Remove all BIG GUID FROM character and update the DATA row with a lower guid*/
ALTER TABLE `characters` DROP PRIMARY KEY;
UPDATE characters JOIN tmp_guid_table ON characters.guid = tmp_guid_table.guid SET characters.guid = `tmp_guid_table`.`guid_new`;
ALTER TABLE `characters` ADD PRIMARY KEY (`guid`);

/*arena_team*/
UPDATE arena_team JOIN tmp_guid_table ON arena_team.captainGuid = tmp_guid_table.guid SET `arena_team`.`captainGuid` = `tmp_guid_table`.`guid_new`;

/*arena_team_member*/
UPDATE arena_team_member JOIN tmp_guid_table ON arena_team_member.guid = tmp_guid_table.guid SET `arena_team_member`.`guid` = `tmp_guid_table`.`guid_new`;

/*Auction House*/ 
UPDATE `auctionhouse` JOIN `tmp_guid_table` ON `auctionhouse`.`buyguid` = `tmp_guid_table`.`guid` SET `auctionhouse`.`buyguid` = `tmp_guid_table`.`guid_new`;
UPDATE `auctionhouse` JOIN `tmp_guid_table` ON `auctionhouse`.`itemowner` = `tmp_guid_table`.`guid` SET `auctionhouse`.`itemowner` = `tmp_guid_table`.`guid_new`;

/*character_account_data*/
ALTER TABLE `character_account_data` DROP PRIMARY KEY;
UPDATE `character_account_data` JOIN `tmp_guid_table` ON `character_account_data`.`guid` = `tmp_guid_table`.`guid` SET `character_account_data`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_account_data` ADD PRIMARY KEY (`guid`, `type`);

/* Character Achievements */
ALTER TABLE `character_achievement` DROP PRIMARY KEY;
UPDATE `character_achievement` JOIN `tmp_guid_table` ON `character_achievement`.`guid` = `tmp_guid_table`.`guid` SET `character_achievement`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_achievement` ADD PRIMARY KEY (guid, achievement);

/* Character Achievements Progress */
ALTER TABLE `character_achievement_progress` DROP PRIMARY KEY;
UPDATE `character_achievement_progress` JOIN `tmp_guid_table` ON `character_achievement_progress`.`guid` = `tmp_guid_table`.`guid` SET `character_achievement_progress`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_achievement_progress` ADD PRIMARY KEY (guid, criteria);

/*Character Action*/
ALTER TABLE `character_action` DROP PRIMARY KEY;
UPDATE `character_action` JOIN `tmp_guid_table` ON `character_action`.`guid` = `tmp_guid_table`.`guid` SET `character_action`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_action` ADD PRIMARY KEY (guid, spec, button);

/*Character Arena Stats*/
ALTER TABLE `character_arena_stats` DROP PRIMARY KEY;
UPDATE `character_arena_stats` JOIN `tmp_guid_table` ON `character_arena_stats`.`guid` = `tmp_guid_table`.`guid` SET `character_arena_stats`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_arena_stats` ADD PRIMARY KEY (guid, slot);

/*Character Aura*/ 
UPDATE `character_aura` JOIN `tmp_guid_table` ON `character_aura`.`guid` = `tmp_guid_table`.`guid` SET `character_aura`.`guid` = `tmp_guid_table`.`guid_new`;

/*character_banned*/
UPDATE `character_banned` JOIN `tmp_guid_table` ON `character_banned`.`guid` = `tmp_guid_table`.`guid` SET `character_banned`.`guid` = `tmp_guid_table`.`guid_new`;

/*character_battleground_data*/
UPDATE `character_battleground_data` JOIN `tmp_guid_table` ON `character_battleground_data`.`guid` = `tmp_guid_table`.`guid` SET `character_battleground_data`.`guid` = `tmp_guid_table`.`guid_new`;

/*character_battleground_random*/
UPDATE `character_battleground_random` JOIN `tmp_guid_table` ON `character_battleground_random`.`guid` = `tmp_guid_table`.`guid` SET `character_battleground_random`.`guid` = `tmp_guid_table`.`guid_new`;

/*character_equipmentsets*/
UPDATE `character_equipmentsets` JOIN `tmp_guid_table` ON `character_equipmentsets`.`guid` = `tmp_guid_table`.`guid` SET `character_equipmentsets`.`guid` = `tmp_guid_table`.`guid_new`;

/*Character Gift*/
UPDATE `character_gifts` JOIN `tmp_guid_table` ON `character_gifts`.`guid` = `tmp_guid_table`.`guid` SET `character_gifts`.`guid` = `tmp_guid_table`.`guid_new`;

/*Character Glyphs*/
ALTER TABLE `character_glyphs` DROP PRIMARY KEY;
UPDATE `character_glyphs` JOIN `tmp_guid_table` ON `character_glyphs`.`guid` = `tmp_guid_table`.`guid` SET `character_glyphs`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_glyphs` ADD PRIMARY KEY (guid, spec);

/*Character Homebind*/
ALTER TABLE `character_homebind` DROP PRIMARY KEY;
UPDATE `character_homebind` JOIN `tmp_guid_table` ON `character_homebind`.`guid` = `tmp_guid_table`.`guid` SET `character_homebind`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_homebind` ADD PRIMARY KEY (guid);

/*Character Instance*/
ALTER TABLE `character_instance` DROP PRIMARY KEY;
UPDATE `character_instance` JOIN `tmp_guid_table` ON `character_instance`.`guid` = `tmp_guid_table`.`guid` SET `character_instance`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_instance` ADD PRIMARY KEY (`guid`,`instance`);

/*Character Inventory*/
ALTER TABLE `character_inventory` DROP INDEX `guid`;
UPDATE `character_inventory` JOIN `tmp_guid_table` ON `character_inventory`.`guid` = `tmp_guid_table`.`guid` SET `character_inventory`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_inventory` ADD UNIQUE INDEX `guid` (`guid`, `bag`, `slot`);

/*Character Pet*/
UPDATE `character_pet` JOIN `tmp_guid_table` ON `character_pet`.`owner` = `tmp_guid_table`.`guid` SET `character_pet`.`owner` = `tmp_guid_table`.`guid_new`;

/*Character Quest Status*/
UPDATE `character_queststatus` JOIN `tmp_guid_table` ON `character_queststatus`.`guid` = `tmp_guid_table`.`guid` SET `character_queststatus`.`guid` = `tmp_guid_table`.`guid_new`;

/*character_queststatus_daily*/
UPDATE `character_queststatus_daily` JOIN `tmp_guid_table` ON `character_queststatus_daily`.`guid` = `tmp_guid_table`.`guid` SET `character_queststatus_daily`.`guid` = `tmp_guid_table`.`guid_new`;

/*character_queststatus_rewarded*/
ALTER TABLE `character_queststatus_rewarded` DROP PRIMARY KEY;
UPDATE `character_queststatus_rewarded` JOIN `tmp_guid_table` ON `character_queststatus_rewarded`.`guid` = `tmp_guid_table`.`guid` SET `character_queststatus_rewarded`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_queststatus_rewarded` ADD PRIMARY KEY (guid, quest);

/*character_queststatus_weekly*/
UPDATE `character_queststatus_weekly` JOIN `tmp_guid_table` ON `character_queststatus_weekly`.`guid` = `tmp_guid_table`.`guid` SET `character_queststatus_weekly`.`guid` = `tmp_guid_table`.`guid_new`;

/*Character Reputation */
ALTER TABLE `character_reputation` DROP PRIMARY KEY;
UPDATE `character_reputation` JOIN `tmp_guid_table` ON `character_reputation`.`guid` = `tmp_guid_table`.`guid` SET `character_reputation`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_reputation` ADD PRIMARY KEY (`guid`, `faction`);

/*Character Skills*/
ALTER TABLE `character_skills` DROP PRIMARY KEY;
UPDATE `character_skills` JOIN `tmp_guid_table` ON `character_skills`.`guid` = `tmp_guid_table`.`guid` SET `character_skills`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_skills` ADD PRIMARY KEY (`guid`, `skill`);

/*Character Social*/
ALTER TABLE `character_social` DROP PRIMARY KEY;
UPDATE `character_social` JOIN `tmp_guid_table` ON `character_social`.`guid` = `tmp_guid_table`.`guid` SET `character_social`.`guid` = `tmp_guid_table`.`guid_new`;
UPDATE `character_social` JOIN `tmp_guid_table` ON `character_social`.`friend` = `tmp_guid_table`.`guid` SET `character_social`.`friend` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_social` ADD PRIMARY KEY (`guid`,`friend`,`flags`);

/*Character Spell*/
ALTER TABLE `character_spell` DROP PRIMARY KEY;
UPDATE `character_spell` JOIN `tmp_guid_table` ON `character_spell`.`guid` = `tmp_guid_table`.`guid` SET `character_spell`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_spell` ADD PRIMARY KEY (guid, spell);

/*Character Spell Cooldown*/ 
UPDATE `character_spell_cooldown` JOIN `tmp_guid_table` ON `character_spell_cooldown`.`guid` = `tmp_guid_table`.`guid` SET `character_spell_cooldown`.`guid` = `tmp_guid_table`.`guid_new`;

/*Character Stats*/
UPDATE `character_stats` JOIN `tmp_guid_table` ON `character_stats`.`guid` = `tmp_guid_table`.`guid` SET `character_stats`.`guid` = `tmp_guid_table`.`guid_new`;

/*Character Talent*/
UPDATE `character_talent` JOIN `tmp_guid_table` ON `character_talent`.`guid` = `tmp_guid_table`.`guid` SET `character_talent`.`guid` = `tmp_guid_table`.`guid_new`;

/*Character Corpse - No need to change anything*/ 
/*Creature Respawn - No need to change anything*/
/*Gameobject Respawn - No need to change anything*/

/*Character Ticket*/ 
UPDATE `gm_tickets` JOIN `tmp_guid_table` ON `gm_tickets`.`guid` = `tmp_guid_table`.`guid` SET `gm_tickets`.`guid` = `tmp_guid_table`.`guid_new`;
UPDATE `gm_tickets` JOIN `tmp_guid_table` ON `gm_tickets`.`closedBy` = `tmp_guid_table`.`guid` SET `gm_tickets`.`closedBy` = `tmp_guid_table`.`guid_new`;
UPDATE `gm_tickets` JOIN `tmp_guid_table` ON `gm_tickets`.`assignedTo` = `tmp_guid_table`.`guid` SET `gm_tickets`.`assignedTo` = `tmp_guid_table`.`guid_new`;

/*Groups*/
ALTER TABLE `groups` DROP PRIMARY KEY;
UPDATE `groups` JOIN `tmp_groups_table` ON `groups`.`guid` = `tmp_groups_table`.`guid` SET `groups`.`guid` = `tmp_groups_table`.`guid_new`;
UPDATE `groups` JOIN `tmp_guid_table` ON `groups`.`leaderGuid` = `tmp_guid_table`.`guid` SET `groups`.`leaderGuid` = `tmp_guid_table`.`guid_new`;
UPDATE `groups` JOIN `tmp_guid_table` ON `groups`.`looterGuid` = `tmp_guid_table`.`guid` SET `groups`.`looterGuid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `groups` ADD PRIMARY KEY (guid);

/*Group Member*/
UPDATE `group_member` JOIN `tmp_groups_table` ON `group_member`.`guid` = `tmp_groups_table`.`guid` SET `group_member`.`guid` = `tmp_groups_table`.`guid_new`;
UPDATE `group_member` JOIN `tmp_guid_table` ON `group_member`.`memberGuid` = `tmp_guid_table`.`guid` SET `group_member`.`memberGuid` = `tmp_guid_table`.`guid_new`;

/*Group Instance*/
UPDATE `group_instance` JOIN `tmp_groups_table` ON `group_instance`.`guid` = `tmp_groups_table`.`guid` SET `group_instance`.`guid` = `tmp_groups_table`.`guid_new`;

/*Character Guild*/
UPDATE `guild` JOIN `tmp_guid_table` ON `guild`.`leaderguid` = `tmp_guid_table`.`guid` SET `guild`.`leaderguid` = `tmp_guid_table`.`guid_new`;

/*Guild Bank Eventlog*/
UPDATE `guild_bank_eventlog` JOIN `tmp_guid_table` ON `guild_bank_eventlog`.`PlayerGuid` = `tmp_guid_table`.`guid` SET `guild_bank_eventlog`.`PlayerGuid` = `tmp_guid_table`.`guid_new`;

/*Guild Bank Item = No need for change*/
/*Guild Bank Right = No need for change*/
/*Guild Bank Tab = No need for change*/

/*Guild Eventlog*/
UPDATE `guild_eventlog` JOIN `tmp_guid_table` ON `guild_eventlog`.`PlayerGuid1` = `tmp_guid_table`.`guid` SET `guild_eventlog`.`PlayerGuid1` = `tmp_guid_table`.`guid_new`;
UPDATE `guild_eventlog` JOIN `tmp_guid_table` ON `guild_eventlog`.`PlayerGuid2` = `tmp_guid_table`.`guid` SET `guild_eventlog`.`PlayerGuid2` = `tmp_guid_table`.`guid_new`;

/*Character Guild Member*/
UPDATE `guild_member` JOIN `tmp_guid_table` ON `guild_member`.`guid` = `tmp_guid_table`.`guid` SET `guild_member`.`guid` = `tmp_guid_table`.`guid_new`;

/*Guild Rank = No need for change*/
/*Instance = No need for change*/
/*Instance Reset = No need for change*/

/*Item instance*/
UPDATE `item_instance` JOIN `tmp_guid_table` ON `item_instance`.`owner_guid` = `tmp_guid_table`.`guid` SET `item_instance`.`owner_guid` = `tmp_guid_table`.`guid_new`;
UPDATE `item_instance` JOIN `tmp_guid_table` ON `item_instance`.`creatorGuid` = `tmp_guid_table`.`guid` SET `item_instance`.`creatorGuid` = `tmp_guid_table`.`guid_new`;
UPDATE `item_instance` JOIN `tmp_guid_table` ON `item_instance`.`giftCreatorGuid` = `tmp_guid_table`.`guid` SET `item_instance`.`giftCreatorGuid` = `tmp_guid_table`.`guid_new`;

/*item_refund_instance*/
UPDATE `item_refund_instance` JOIN `tmp_guid_table` ON `item_refund_instance`.`player_guid` = `tmp_guid_table`.`guid` SET `item_refund_instance`.`player_guid` = `tmp_guid_table`.`guid_new`;

/*Item Soulbound Trade Data* -- No change necesary*/

/*Character Mail*/ 
UPDATE `mail` JOIN `tmp_guid_table` ON `mail`.`sender` = `tmp_guid_table`.`guid` SET `mail`.`sender` = `tmp_guid_table`.`guid_new`;
UPDATE `mail` JOIN `tmp_guid_table` ON `mail`.`receiver` = `tmp_guid_table`.`guid` SET `mail`.`receiver` = `tmp_guid_table`.`guid_new`;

/*Mail Items*/
UPDATE `mail_items` JOIN `tmp_guid_table` ON `mail_items`.`receiver` = `tmp_guid_table`.`guid` SET `mail_items`.`receiver` = `tmp_guid_table`.`guid_new`;

/*Pet Aura = No changes needed*/
/*Pet Spell - No changes needed*/
/*Pet Spell Cooldown - No changes needed*/

/*Character Petition*/ 
UPDATE `petition` JOIN `tmp_guid_table` ON `petition`.`ownerguid` = `tmp_guid_table`.`guid` SET `petition`.`ownerguid` = `tmp_guid_table`.`guid_new`;

/*Character Petition Sign*/ 
UPDATE `petition_sign` JOIN `tmp_guid_table` ON `petition_sign`.`playerguid` = `tmp_guid_table`.`guid` SET `petition_sign`.`playerguid` = `tmp_guid_table`.`guid_new`;


/* CUSTOM TABLES */

/*Characters Recruit a Friend*/
/*ALTER TABLE `character_raf` DROP PRIMARY KEY;
UPDATE `character_raf` JOIN `tmp_guid_table` ON `character_raf`.`guid` = `tmp_guid_table`.`guid` SET `character_raf`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_raf` ADD PRIMARY KEY (`guid`);*/

/*Character XP Rates*/
/*ALTER TABLE `character_xp_rates` DROP PRIMARY KEY;
UPDATE `character_xp_rates` JOIN `tmp_guid_table` ON `character_xp_rates`.`guid` = `tmp_guid_table`.`guid` SET `character_xp_rates`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `character_xp_rates` ADD PRIMARY KEY (`guid`);*/

/*Player Report Status - No change necesary*/

/*Lotto Extractions*/
/*ALTER TABLE `lotto_extractions` DROP PRIMARY KEY;
UPDATE `lotto_extractions` JOIN `tmp_guid_table` ON `lotto_extractions`.`guid` = `tmp_guid_table`.`guid` SET `lotto_extractions`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `lotto_extractions` ADD PRIMARY KEY (`winner`);*/

/*Lotto Tickets*/
/*ALTER TABLE `lotto_tickets` DROP PRIMARY KEY;
UPDATE `lotto_tickets` JOIN `tmp_guid_table` ON `lotto_tickets`.`guid` = `tmp_guid_table`.`guid` SET `lotto_tickets`.`guid` = `tmp_guid_table`.`guid_new`;
ALTER TABLE `lotto_tickets` ADD PRIMARY KEY (`id`);*/



/*Remove all BIG GUID FROM item_instance and update the DATA row with a lower guid*/
DELETE FROM `auctionhouse` WHERE `itemguid` NOT IN (SELECT `guid` FROM `item_instance`);
DELETE FROM `character_gifts` WHERE `item_guid` NOT IN (SELECT `guid` FROM `item_instance`);
DELETE FROM `character_inventory` WHERE `item` NOT IN (SELECT `guid` FROM `item_instance`);
DELETE FROM `guild_bank_item` WHERE `item_guid` NOT IN (SELECT `guid` FROM `item_instance`);
DELETE FROM `mail_items` WHERE `item_guid` NOT IN (SELECT `guid` FROM `item_instance`);
DELETE FROM `petition` WHERE `petitionguid` NOT IN ( SELECT `guid` FROM `item_instance` );
DELETE FROM `petition_sign` WHERE `petitionguid` NOT IN (SELECT `petitionguid` FROM `petition` );


DROP TABLE IF EXISTS `tmp_table0`;
CREATE TABLE `tmp_table0` (
  `id_ah` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  USING HASH (`id_ah`),
  KEY `id_ah` USING HASH (`id_ah`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
INSERT INTO `tmp_table0` (id_ah) SELECT `itemguid` FROM `auctionhouse`;

DROP TABLE IF EXISTS `tmp_table1`;
CREATE TABLE `tmp_table1` (
  `id_cg` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  USING HASH (`id_cg`),
  KEY `id_cg` USING HASH (`id_cg`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
INSERT INTO `tmp_table1` (id_cg) SELECT `item_guid` FROM `character_gifts`;

DROP TABLE IF EXISTS `tmp_table2`;
CREATE TABLE `tmp_table2` (
  `id_ci` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  USING HASH (`id_ci`),
  KEY `id_ci` USING HASH (`id_ci`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
INSERT INTO `tmp_table2` (id_ci) SELECT `item` FROM `character_inventory`;

DROP TABLE IF EXISTS `tmp_table3`;
CREATE TABLE `tmp_table3` (
  `id_gb` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  USING HASH (`id_gb`),
  KEY `id_gb` USING HASH (`id_gb`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
INSERT INTO `tmp_table3` (id_gb) SELECT `item_guid` FROM `guild_bank_item`;

DROP TABLE IF EXISTS `tmp_table4`;
CREATE TABLE `tmp_table4` (
  `id_mi` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  USING HASH (`id_mi`),
  KEY `id_mi` USING HASH (`id_mi`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
INSERT INTO `tmp_table4` (id_mi) SELECT `item_guid` FROM `mail_items`;

DELETE FROM `item_instance` WHERE `guid` NOT IN (SELECT `id_ah` FROM `tmp_table0`)
							  AND `guid` NOT IN (SELECT `id_cg` FROM `tmp_table1`)
						      AND `guid` NOT IN (SELECT `id_ci` FROM `tmp_table2`)
							  AND `guid` NOT IN (SELECT `id_gb` FROM `tmp_table3`)
							  AND `guid` NOT IN (SELECT `id_mi` FROM `tmp_table4`)
							  AND `guid` NOT IN (SELECT `petitionguid` FROM `petition`)
							  AND `guid` NOT IN (SELECT `petitionguid` FROM `petition_sign`);

		  
/* Item Instance */
ALTER TABLE `item_instance` DROP PRIMARY KEY;
ALTER TABLE `item_instance` AUTO_INCREMENT = 1;
ALTER TABLE `item_instance` ADD COLUMN `guid_new` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT FIRST,  ADD PRIMARY KEY (`guid_new`);

DROP TABLE IF EXISTS `tmp_item_instance_table`;
CREATE TABLE `tmp_item_instance_table` (
	`guid` INT(10) unsigned NOT NULL,
	`guid_new` INT(10) unsigned NOT NULL PRIMARY KEY,
	INDEX USING HASH (guid),
	INDEX USING HASH (guid_new)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
INSERT INTO `tmp_item_instance_table` (guid, guid_new) SELECT `guid`, `guid_new` FROM `item_instance`;

ALTER TABLE `item_instance` DROP COLUMN `guid`;
ALTER TABLE `item_instance` CHANGE COLUMN `guid_new` `guid` INT(10) UNSIGNED NOT NULL DEFAULT '0', DROP PRIMARY KEY, ADD PRIMARY KEY (`guid`);

/*Auction House*/
UPDATE `auctionhouse` JOIN `tmp_item_instance_table` ON `auctionhouse`.`itemguid` = `tmp_item_instance_table`.`guid` SET `auctionhouse`.`itemguid` = `tmp_item_instance_table`.`guid_new`;

/*Character Gifts*/
UPDATE `character_gifts` JOIN `tmp_item_instance_table` ON `character_gifts`.`item_guid` = `tmp_item_instance_table`.`guid` SET `character_gifts`.`item_guid` = `tmp_item_instance_table`.`guid_new`;

/*Character Inventory*/
ALTER TABLE `character_inventory` DROP INDEX `guid`;
UPDATE `character_inventory` JOIN `tmp_item_instance_table` ON `character_inventory`.`bag` = `tmp_item_instance_table`.`guid` SET `character_inventory`.`bag` = `tmp_item_instance_table`.`guid_new` WHERE `character_inventory`.`bag` != 0;
ALTER TABLE `character_inventory` ADD UNIQUE INDEX `guid` (`guid`, `bag`, `slot`);

ALTER TABLE `character_inventory` DROP PRIMARY KEY;
UPDATE `character_inventory` JOIN `tmp_item_instance_table` ON `character_inventory`.`item` = `tmp_item_instance_table`.`guid` SET `character_inventory`.`item` = `tmp_item_instance_table`.`guid_new`;
ALTER TABLE `character_inventory` ADD PRIMARY KEY (`item`);

/*Guild Bank Item*/
ALTER TABLE `guild_bank_item` DROP INDEX `Idx_item_guid`;
UPDATE `guild_bank_item` JOIN `tmp_item_instance_table` ON `guild_bank_item`.`item_guid` = `tmp_item_instance_table`.`guid` SET `guild_bank_item`.`item_guid` = `tmp_item_instance_table`.`guid_new`;
ALTER TABLE `guild_bank_item` ADD UNIQUE INDEX `idx_item_guid`(`item_guid`);

/*Mail Items*/
UPDATE `mail_items` JOIN `tmp_item_instance_table` ON `mail_items`.`item_guid` = `tmp_item_instance_table`.`guid` SET `mail_items`.`item_guid` = `tmp_item_instance_table`.`guid_new`;

/*Petition*/
UPDATE `petition`, `tmp_item_instance_table` SET `petition`.`petitionguid` = `tmp_item_instance_table`.`guid` WHERE `petition`.`petitionguid` = `tmp_item_instance_table`.`guid_new`;

/*Petition Sign*/
UPDATE `petition_sign`, `tmp_item_instance_table` SET `petition_sign`.`petitionguid` = `tmp_item_instance_table`.`guid` WHERE `petition_sign`.`petitionguid` = `tmp_item_instance_table`.`guid_new`;



/*Remove all BIG GUID FROM character_pet and update the DATA row with a lower guid*/
DROP TABLE IF EXISTS `tmp_character_pet_table`;
CREATE TABLE `tmp_character_pet_table` (	
	`id_new` INT(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`id` INT(10) unsigned NOT NULL,
	INDEX USING HASH (id_new),
	INDEX USING HASH (id)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
INSERT INTO `tmp_character_pet_table` (id) SELECT `id` FROM `character_pet`;

ALTER TABLE `character_pet` DROP PRIMARY KEY;
UPDATE character_pet JOIN tmp_character_pet_table ON character_pet.id = tmp_character_pet_table.id SET character_pet.id = `tmp_character_pet_table`.`id_new`;
ALTER TABLE `character_pet` ADD PRIMARY KEY (`id`);

/* Pet Aura */
ALTER TABLE `pet_aura` DROP PRIMARY KEY;
UPDATE pet_aura JOIN tmp_character_pet_table ON pet_aura.guid = tmp_character_pet_table.id SET pet_aura.guid = `tmp_character_pet_table`.`id_new`;
ALTER TABLE `pet_aura` ADD PRIMARY KEY (`guid`,`spell`,`effect_mask`);

/*Pet Spell */
ALTER TABLE `pet_spell` DROP PRIMARY KEY;
UPDATE pet_spell JOIN tmp_character_pet_table ON pet_spell.guid = tmp_character_pet_table.id SET pet_spell.guid = `tmp_character_pet_table`.`id_new`;
ALTER TABLE `pet_spell` ADD PRIMARY KEY (`guid`,`spell`);

/* Pet Spell Cooldown */
ALTER TABLE `pet_spell_cooldown` DROP PRIMARY KEY;
UPDATE pet_spell_cooldown JOIN tmp_character_pet_table ON pet_spell_cooldown.guid = tmp_character_pet_table.id SET pet_spell_cooldown.guid = `tmp_character_pet_table`.`id_new`;
ALTER TABLE `pet_spell_cooldown` ADD PRIMARY KEY (`guid`,`spell`);


/*Remove all BIG GUID FROM mail and update the DATA row with a lower guid*/
ALTER TABLE `mail` DROP PRIMARY KEY;
ALTER TABLE `mail` AUTO_INCREMENT = 1;
ALTER TABLE `mail` ADD `guid_new` INT( 11 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
ALTER TABLE `mail` CHANGE `guid_new` `guid_new` INT( 11 ) UNSIGNED NOT NULL default '0';
ALTER TABLE `mail` DROP PRIMARY KEY;
UPDATE `mail` SET `guid_new` = `guid_new` + 0;

/*Mail Items*/
ALTER TABLE `mail_items` ADD COLUMN `mail_id2` INTEGER AFTER `mail_id`;
UPDATE `mail_items` SET mail_id2=mail_id;
UPDATE `mail_items`, `mail` SET `mail_items`.`mail_id2` = `mail`.`guid_new` WHERE `mail_items`.`mail_id` = `mail`.`id`;
ALTER TABLE `mail_items` DROP PRIMARY KEY,
						 DROP COLUMN `mail_id`,
						 CHANGE COLUMN `mail_id2` `mail_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
						 ADD PRIMARY KEY(`mail_id`,`item_guid`);

/*recover GUID mail*/
ALTER TABLE `mail` DROP `id`;
ALTER TABLE `mail` CHANGE `guid_new` `id` INT( 11 ) UNSIGNED NOT NULL default '0' PRIMARY KEY COMMENT 'Identifier';


/* Cleanup */
DROP TABLE IF EXISTS `tmp_guid_table`;
DROP TABLE IF EXISTS `tmp_groups_table`;
DROP TABLE IF EXISTS `tmp_item_instance_table`;
DROP TABLE IF EXISTS `tmp_character_pet_table`;

DROP TABLE IF EXISTS `tmp_table0`;
DROP TABLE IF EXISTS `tmp_table1`;
DROP TABLE IF EXISTS `tmp_table2`;
DROP TABLE IF EXISTS `tmp_table3`;
DROP TABLE IF EXISTS `tmp_table4`;
-- END --
