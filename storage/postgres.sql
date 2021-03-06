create table if not exists guilds (
    guild_id VARCHAR (24) PRIMARY KEY,
    guild_name VARCHAR (100) NOT NULL,
    premium VARCHAR (20)
);

create table if not exists games (
    game_id bigint PRIMARY KEY,
    connect_code CHAR(8) NOT NULL,
    start_time bigint NOT NULL,
    win_type VARCHAR (20), --imposter win, crewmate win, etc
    end_time bigint
);

-- links userIDs to their hashed variants.
-- Use the hashed_id as PKEY so users can wipe their association without deleting all linked data!
create table if not exists users (
    user_id VARCHAR (24),
    hashed_user_id CHAR(64) PRIMARY KEY
);

create table if not exists guilds_users (
    guild_id VARCHAR (24) REFERENCES guilds,
    hashed_user_id CHAR(64) REFERENCES users ON DELETE CASCADE, --if a user is deleted, delete linked guilds_users
    PRIMARY KEY (guild_id, hashed_user_id)
);

create table if not exists guilds_games (
    guild_id VARCHAR (24) REFERENCES guilds ON DELETE CASCADE, --if a guild is deleted, delete all linked guild_games
    game_id bigint REFERENCES games,
    PRIMARY KEY (guild_id, game_id)
);

create table if not exists users_games (
    hashed_user_id CHAR(64) REFERENCES users,
    game_id bigint REFERENCES games ON DELETE CASCADE, --if a game is deleted, delete all linked users_games
    player_name VARCHAR(10) NOT NULL,
    player_color smallint NOT NULL,
    player_role VARCHAR(10), --futureproofing
    winner boolean,
    PRIMARY KEY (hashed_user_id, game_id)
);

-- Example queries:
-- How many games has (h_uid) played? `SELECT COUNT(game_id) FROM users_games WHERE hashed_user_id=huid`
-- How many games have been played on (g_id)? `SELECT COUNT(guild_id) FROM guilds_games WHERE guild_id=g_id`
-- TBD

