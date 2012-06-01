-- TODO REBUILD
/*
ALTER TABLE realmd.`account` CHANGE `id` `id` INT( 11 ) UNSIGNED NOT NULL;
ALTER TABLE realmd.`account` DROP PRIMARY KEY;
ALTER TABLE realmd.`account` AUTO_INCREMENT = 1;
ALTER TABLE realmd.`account` ADD `id_nou` INT( 11 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Global Unique Identifier FIRST' after `id`;

-- trebuie sterse banurile pe conturile care nu mai exista--
delete from realmd.account_banned where id not in (select id from realmd.account);


update realmd.account_banned set id = (select id_nou from realmd.account where realmd.account.id = realmd.account_banned.id);


-- cleanup realmcharacters - a se adauga conditia where in caz ca exista mai multe realmuri
delete from realmcharacters where acctid not in (select id from realmd.account);

update characters.characters set account = (select id_nou from realmd.account where realmd.account.id = characters.characters.account);

alter table realmd.account drop id;
ALTER TABLE realmd.account CHANGE id_nou id INT( 11 ) UNSIGNED NOT NULL AUTO_INCREMENt;
*/