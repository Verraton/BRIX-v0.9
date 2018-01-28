//##############################################################################
//# www.brixonline.eu

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// IMPORTANT SETTINGS BELOW. IS IT SAFE TO EDIT THESE?
// [ ] YES
// [x] NO

local Admin = array(MAX_PLAYERS, 0);
local Logged = array(MAX_PLAYERS, 0);
local Login = array(MAX_PLAYERS, 0);
local MsgAccess = array(MAX_PLAYERS, 0);

local playerVehicles = {};

local spamprotect = array(MAX_PLAYERS, 0);

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// GENERAL SETTINGS BELOW. IS IT SAFE TO EDIT THESE?
// [x] YES
// [ ] NO

local colorError = [255, 255, 255];
local colorInfo = [255, 255, 255];
local colorNormal = [255, 255, 255];
local colorPositive = [255, 255, 255];
local colorNegative = [255, 255, 255];
local colorPastel = [255, 255, 255];
local colorRole = [255, 255, 255];

local serverName = getServerName();
local serverAdmin = ("");
local serverWebsite = ("www.brixonline.eu");
local serverMsgPrefix = ("");

local adminSerial = ("");
local rconPassword = ("");

local connectMessage_1 = (""); 
local connectMessage_2 = ("");

local spawnMessage_1 = ("");
local spawnMessage_2 = ("");

local randomizeOnSpawn = 0;
local defaultModel = 1;
local spawnHealthAmount = 720.0;

local allowWeapons = 0;
local spawnWeapon = 4;
local spawnWeaponAmmo = 16;

local randomSpawnPoint = 0;
local spawnPosition = [-393.188, 910.936, -20.0026];
local randomSpawnPos1 = [-393.188, 910.936, -20.0026];
local randomSpawnPos2 = [-393.188, 910.936, -20.0026];
local randomSpawnPos3 = [-393.188, 910.936, -20.0026]; 
local randomSpawnPos4 = [-393.188, 910.936, -20.0026];

local useDefaultPlates = 1;
local defaultPlates = "BRIX";

GLOBAL_HOURS <- 12;
GLOBAL_MINUTES <- 0;
GLOBAL_SECONDS <- 0;
GLOBAL_TIME <- "12:00";

SERVER_TIME_SPEED <- 500; // 500
SERVER_IS_SUMMER <- false;
SERVER_WEATHER <- "DT_RTRclear_day_noon";

WEATHER_CHANGE_TRIGGER <- 10;

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// LAUNCHING SETTINGS BELOW. IS IT SAFE TO EDIT THESE?
// [ ] YES
// [x] NO

local scriptName = "BRIX";
function scriptInit() {
    log( "Successfully loaded " + scriptName + ".");
    log( "==============================================================");
    log( "Made by Bularthip. Visit www.brixonline.eu");
    log( "Special thanks to Rolandd and the community");
    log( "==============================================================");
    setGameModeText( "BRIX v0.9" );
    setMapName( "Empire Bay" );

    timer( autoMsg, 600000, -1 ); // 600000=10 minutes, 1000=1 second
    timer( pulse, 120000, -1 ); // PULSE

    setSummer(SERVER_IS_SUMMER);
    timer(Time, SERVER_TIME_SPEED, -1);
}
addEventHandler( "onScriptInit", scriptInit );

function onExit() {
    log( scriptName + " unloaded. Why? Are you sure this is normal?" );
}
addEventHandler( "onScriptExit", onExit );

function onConsoleCommand( command, params ) {
    log( "Console command: " + command + " | Params: " + params );
}
addEventHandler( "onConsoleInput", onConsoleCommand );

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// IMPORTANT FUNCTIONS BELOW. IS IT SAFE TO EDIT THESE?
// [ ] YES
// [x] NO

function random (min = 0, max = RAND_MAX) {
    srand((getTickCount() * rand()));
    return (rand() % ((max.tointeger() + 1) - min.tointeger())) + min.tointeger();
}

function isNumeric( string ) {
    try
    {
        string.tointeger()
    }
    catch( string )
    {
        return 0;
    }

    return 1;
}

function pulse() {
	log("Heartbeat");
}

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// CONNECTING / DISCONNECTING / OTHER SETTINGS BELOW. IS IT SAFE TO EDIT THESE?
// [x] YES
// [ ] NO

function playerConnect( playerid, name, ip, serial ) {
    sendPlayerMessageToAll( serverMsgPrefix + ": Welcome, " + getPlayerName( playerid ) + "!", colorInfo[0], colorInfo[1], colorInfo[2] );
    sendPlayerMessage(playerid, connectMessage_1, colorPositive[0], colorPositive[1], colorPositive[2] );
    sendPlayerMessage(playerid, connectMessage_2, colorPositive[0], colorPositive[1], colorPositive[2] );

    Admin[playerid] = 0;
    Logged[playerid] = 0;
    MsgAccess[playerid] = 1;
    playerWeather[playerid] = "";

}
addEventHandler( "onPlayerConnect", playerConnect );

function playerDisconnect( playerid, reason ) {
    sendPlayerMessageToAll( serverMsgPrefix + ": " + getPlayerName( playerid ) + " has " + reason + ".", colorInfo[0], colorInfo[1], colorInfo[2] );

    Admin[playerid] = 0;
    Logged[playerid] = 0;
    MsgAccess[playerid] = 0;

    if (playerid in playerVehicles)
    {
        destroyVehicle(playerVehicles[playerid]);
        delete playerVehicles[playerid];
        log("Deleted player vehicle upon quit from " + getPlayerName(playerid) + ".");
    }

    local netInfo = getPlayerNetworkStats( playerid );
    log( netInfo["ConnectionTime"] + " | " + netInfo["TotalPacketLoss"] );
}
addEventHandler( "onPlayerDisconnect", playerDisconnect );

function onConnectionRefused( playerid, reason ) {
    if (reason == REJECT_REASON_BANNED)
    {
        return  0;
    }
    return  1;
}
addEventHandler( "onPlayerConnectionRejected", onConnectionRefused );

function nickNameChanged( playerid, newNickname, oldNickname ) {
    sendPlayerMessageToAll( serverMsgPrefix + ": " + oldNickname+ " is now known as " +  newNickname + ".", colorInfo[0], colorInfo[1], colorInfo[2] );
    return 1;
}
addEventHandler ( "onPlayerChangeNick", nickNameChanged );

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// SPAWNING / DYING SETTINGS BELOW. IS IT SAFE TO EDIT THESE?
// [x] YES
// [ ] NO

function playerSpawn( playerid) {
    spamprotect[playerid] = 0;

    sendPlayerMessage(playerid, serverMsgPrefix + ": " + spawnMessage_1, colorInfo[0], colorInfo[1], colorInfo[2] );
    sendPlayerMessage(playerid, serverMsgPrefix + ": " + spawnMessage_2, colorInfo[0], colorInfo[1], colorInfo[2] );

    if (randomizeOnSpawn)
    {
        setPlayerModel( playerid, (rand() % 155) );
    }
    else {
        setPlayerModel( playerid, defaultModel);
    }

    if (randomSpawnPoint)
    {
        switch(random(0,3))
        {
            case 0:
            setPlayerPosition(playerid, randomSpawnPos1[0], randomSpawnPos1[1], randomSpawnPos1[2] );
            log ("Player " + getPlayerName(playerid) + " spawning at #1.");
            break;
            case 1:
            setPlayerPosition(playerid, randomSpawnPos2[0], randomSpawnPos2[1], randomSpawnPos2[2] );
            log ("Player " + getPlayerName(playerid) + " spawning at #2.");
            break;
            case 2:
            setPlayerPosition(playerid, randomSpawnPos3[0], randomSpawnPos3[1], randomSpawnPos3[2] );
            log ("Player " + getPlayerName(playerid) + " spawning at #3.");
            break;
            case 3:
            setPlayerPosition(playerid, randomSpawnPos4[0], randomSpawnPos4[1], randomSpawnPos4[2] );
            log ("Player " + getPlayerName(playerid) + " spawning at #4.");
            break;
        } 
    }
    else {
        setPlayerPosition( playerid, spawnPosition[0], spawnPosition[1], spawnPosition[2] );
    }

    setPlayerHealth( playerid, spawnHealthAmount );

    if (allowWeapons)
    {
        givePlayerWeapon(playerid, spawnWeapon, spawnWeaponAmmo);
    }

}
addEventHandler( "onPlayerSpawn", playerSpawn );

function playerDeath( playerid, killerid ) {
    if( killerid != INVALID_ENTITY_ID )
    {
        sendPlayerMessageToAll( serverMsgPrefix + ": " + getPlayerName( playerid ) + " was killed by " + getPlayerName( killerid ) + ".", colorInfo[0], colorInfo[1], colorInfo[2] ); 
    }
    else {
        sendPlayerMessageToAll(serverMsgPrefix + ": " + getPlayerName( playerid ) + " is now sleeping with the fishes.", colorInfo[0], colorInfo[1], colorInfo[2] );
    }
}
addEventHandler( "onPlayerDeath", playerDeath );

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// GENERAL HELP COMMAND BELOW. IS IT SAFE TO EDIT THESE?
// [x] YES
// [ ] NO

addCommandHandler( "help", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /help [TYPE].", colorError[0], colorError[1], colorError[2] );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Types are: general | teleporting | vehicles | weapons | chat", colorInfo[0], colorInfo[1], colorInfo[2] );
        log( getPlayerName(playerid) + " used /help.");
        return 1;
    }
    else {
        local area = vargv[0].tostring();
        if( area == "general" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "-General Commands-", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/model - Set character model (skin)", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/randomize - Randomize character model (skin)", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/heal", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/health - Set health to X", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/unlock - Unlock controls", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action - Use actions / emotions", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "-End of general commands-", colorPositive[0], colorPositive[1], colorPositive[2] );
            log( getPlayerName(playerid) + " used /help general.");
        }
        else if( area == "teleporting" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "-Teleporting Commands-", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/goto - Teleport to another player", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/tele - Teleport to another location", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/mypos - Get current coordinates", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "-End of teleporting command-", colorPositive[0], colorPositive[1], colorPositive[2] );
            log( getPlayerName(playerid) + " used /help teleporting.");
        }
        else if( area == "vehicles" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "-Vehicle Commands-", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/vehicle - Spawn a vehicle", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/randomveh - Spawn a random vehicle", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/tune - Tune vehicle", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/plates - Set vehicle plates to X", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/repair - Repair vehicle", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/paint - Paint vehicle (RGB)", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/dirt - Shit the vehicle up", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/wheels - Set vehicle wheels", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/vehicleinfo  - Get vehicle information", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/taxi - Turn on Taxi light", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/lights - Turn on lights", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/open and /close - Open or close trunk or hood", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "-End of vehicle commands", colorPositive[0], colorPositive[1], colorPositive[2] ); 
            log( getPlayerName(playerid) + " used /help vehicles.");       
        }
        else if( area == "weapons" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "-Weapon Commands-", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/weapon - Spawn a weapon", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/reload - Reload weapon (ammo)", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "-End of weapon commands-", colorPositive[0], colorPositive[1], colorPositive[2] );
            log( getPlayerName(playerid) + " used /help weapons.");
        }
        else if( area == "chat" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "-Chat Commands-", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/pm - Send a private message", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/automsg  - Enable or disable automatic messages", colorPositive[0], colorPositive[1], colorPositive[2] );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "-End of chatting commands-", colorPositive[0], colorPositive[1], colorPositive[2] );
            log( getPlayerName(playerid) + " used /help chat.");
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [TYPE]!", colorError[0], colorError[1], colorError[2] );
        }
    }
}
);

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// AUTOASSIST FUNCTION BELOW. IS IT SAFE TO EDIT THIS?
// [x] YES
// [ ] NO

function playerChat( playerid, chattext ) {
    if(chattext.tolower() == "help" || (chattext.tolower() == "help me") || (chattext.tolower() == "hlep") || (chattext.tolower() == "help!") || (chattext.tolower() == "help!!"))
    {
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Hello, " + getPlayerName(playerid) + ". Do you need help?", colorPastel[0], colorPastel[1], colorPastel[2] );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Type /help to list all commands available. Contact " + serverAdmin + " (Admin) for support." , colorPastel[0], colorPastel[1], colorPastel[2] );
        log( getPlayerName(playerid) + " triggered autoassistant(" + chattext + ")");
    } 
    else if(chattext.tolower() == "stuck" || (chattext.tolower() == "im stuck") || (chattext.tolower() == "cant move") || (chattext.tolower() == "ah im stuck") || (chattext.tolower() == "oh im stuck") || (chattext.tolower() == "shit im stuck") || (chattext.tolower() == "fuck im stuck") || (chattext.tolower() == "cant move"))
    {
        togglePlayerControls( playerid, false );        
        local pos = getPlayerPosition(playerid);
        switch(random(0,3))
        {
            case 0:
            setPlayerPosition(playerid, pos[0] + 1, pos[1], pos[2] +0.5);
            break;
            case 1:
            setPlayerPosition(playerid, pos[0], pos[1] + 1, pos[2] +0.5);
            break;
            case 2:
            setPlayerPosition(playerid, pos[0] - 1, pos[1], pos[2] +0.5);
            break;
            case 3:
            setPlayerPosition(playerid, pos[0], pos[1] - 1, pos[2] +0.5);
            break;
        }   
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Hello, " + getPlayerName(playerid) + ". Your controls have been unlocked.", colorPastel[0], colorPastel[1], colorPastel[2] );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "If you're still stuck, you can respawn by typing /health 0.", colorPastel[0], colorPastel[1], colorPastel[2] );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "NOTE: you will die and respawn at spawn location.", colorPastel[0], colorPastel[1], colorPastel[2] );
    }
    else if(chattext.tolower() == "admin" || (chattext.tolower() == "admin!") || (chattext.tolower() == "admin?"))
    {
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Hello, " + getPlayerName(playerid) + ". It looks like you're trying to contact our staff.", colorPastel[0], colorPastel[1], colorPastel[2] );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "The server Administrator is " + serverAdmin + ". If you can't reach him right now, visit our website for contact information.", colorPastel[0], colorPastel[1], colorPastel[2] );
        log( getPlayerName(playerid) + " triggered autoassistant(" + chattext + ")");
    }
    return 1;
}
addEventHandler( "onPlayerChat", playerChat );

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// SPAMPROTECT FUNCTION BELOW. IS IT SAFE TO EDIT THIS?
// [x] YES
// [ ] NO

function playerChat( playerid, chattext ) {
    if ( spamprotect[playerid] > 1 )
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Stop spamming! This message was not sent.", colorError[0], colorError[1], colorError[2] );
        log( getPlayerName(playerid) + " spamming! Message not sent.");
        return 0;
    }
    else {
        spamprotect[playerid]++;
        timer( function() { spamprotect[playerid] = 0; }, 6000, 1);
        return 1;
    }
}
addEventHandler( "onPlayerChat", playerChat );

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// IMPORTANT FUNCTIONS BELOW. IS IT SAFE TO EDIT THESE?
// [x] YES
// [ ] NO

function vehicleEnter( playerid, veh, seat ) {
    if(isPlayerInVehicle(playerid) )
    {
        local model = getVehicleModel ( getPlayerVehicle ( playerid ) );
        local vehicleid = getPlayerVehicle(playerid);

        log( getPlayerName(playerid) + " enters vehID " + vehicleid);
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Vehicle model: " + getVehicleModel(vehicleid) ". Use /vehicleinfo for detailed specs.", colorInfo[0]".", colorInfo[1], colorInfo[2] ); 
        if(model == 42 || (model == 51 ))//42 51
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You can reset this vehicle paint by typing /resetpaint!", colorInfo[0], colorInfo[1], colorInfo[2] ); 
        }
        else if(model == 33 || (model == 24 )) //33 24
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You can turn on your Taxi Light by typing /taxi on!", colorInfo[0], colorInfo[1], colorInfo[2] );
        }
    }

}
addEventHandler( "onPlayerVehicleEnter", vehicleEnter );

function autoMsg() {
    for(local i = 0; i < getMaxPlayers(); i++)
    {
        if(isPlayerConnected(i))
        {
            if(MsgAccess[i] == 1)
            {
                switch(random(0,4))
                {
                    case 0:
                    sendPlayerMessage(i, serverMsgPrefix + ": " +"You can disable automatic messages with /automsg.", colorInfo[0], colorInfo[1], colorInfo[2] );
                    break;

                    case 1:
                    sendPlayerMessage(i, serverMsgPrefix + ": " +"Get your free TeamSpeak 3 channel at www.brixonline.eu!", colorInfo[0], colorInfo[1], colorInfo[2] );
                    break;

                    case 2:
                    sendPlayerMessage(i, serverMsgPrefix + ": " +"Need help? The server administrator is + " serverAdmin + " and you can find more information at " + serverWebsite + ".", colorInfo[0], colorInfo[1], colorInfo[2] );
                    break;

                    case 3:
                    sendPlayerMessage(i, serverMsgPrefix + ": " +"You can view all the commands by typing /help.", colorInfo[0], colorInfo[1], colorInfo[2] );
                    break;

                    case 4:
                    sendPlayerMessage(i, serverMsgPrefix + ": " +"Misbehaving players will be removed from the server!", colorInfo[0], colorInfo[1], colorInfo[2] );
                    break;

                    log( "Automessage timer tick");
                }
            }
        }
    }
}

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// PLAYER COMMANDS BELOW. IS IT SAFE TO EDIT THESE?
// [x] YES
// [ ] NO

addCommandHandler( "vehicle", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /vehicle [ID].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local id = vargv[0].tostring();   
        if( isNumeric(id) )
        {
            if( id.tointeger() < 54 && -1 < id.tointeger() )
            {
                if( isPlayerInVehicle( playerid ) )
                {
                    sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +"You have to leave your vehicle first.", colorError[0], colorError[1], colorError[2] );
                }
                else {
                    if (playerid in playerVehicles)
                    {
                        sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Destroying old vehicle and spawning a new one.", colorInfo[0], colorInfo[1], colorInfo[2] );
                        log("Destorying vehID " + playerVehicles[playerid] + " from " + getPlayerName(playerid) + ".");
                        destroyVehicle(playerVehicles[playerid]);

                    }
                    local pos = getPlayerPosition( playerid );
                    local rot = getPlayerRotation( playerid );

                    timer( function() { 
                        playerVehicles[playerid] <- createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, rot[1], 0.0 );
                        log("Spawning vehID " + playerVehicles[playerid] + " (model " + getVehicleModel(playerVehicles[playerid]) + ") for " + getPlayerName(playerid) + ".");
                        }, 500, 1);
                    if(useDefaultPlates)
                    {          
                        timer( function() { setVehiclePlateText(playerVehicles[playerid], defaultPlates); }, 1500, 1);
                    }       
                }
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Vehicle ID's: 0-53.", colorError[0], colorError[1], colorError[2] );
            }
        } 
    }
}
);

addCommandHandler( "randomvehicle", function( playerid ) {
    if( isPlayerInVehicle( playerid ) )
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +"You have to leave your vehicle first.", colorError[0], colorError[1], colorError[2] );
    }
    else {
        if (playerid in playerVehicles)
        {
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Destroying old vehicle and spawning a new one.", colorInfo[0], colorInfo[1], colorInfo[2] );
            log("Destorying vehID " + playerVehicles[playerid] + " from " + getPlayerName(playerid) + ".");
            destroyVehicle(playerVehicles[playerid]);
        }
        local pos = getPlayerPosition( playerid );
        local rot = getPlayerRotation( playerid );
        timer( function() { 
        playerVehicles[playerid] <- createVehicle( (rand() % 54), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, rot[1], 0.0 );
        log("Spawning vehID " + playerVehicles[playerid] + " (model " + getVehicleModel(playerVehicles[playerid]) + ") for " + getPlayerName(playerid) + ".");
        }, 500, 1);

        if(useDefaultPlates)
        {
            timer( function() { setVehiclePlateText(playerVehicles[playerid], defaultPlates); }, 1500, 1);
        }       
    }
}
);

addCommandHandler( "lights", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /lights [OPTION].", colorError[0], colorError[1], colorError[2] );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Options are: on | off", colorInfo[0], colorInfo[1], colorInfo[2] );
        return 1;
    }
    else {
        local option = vargv[0].tostring();
        if( isPlayerInVehicle( playerid ) )
        {
            local id = getPlayerVehicle(playerid);
            if( option == "on" )
            {
                setVehicleLightState(id, true );
                log( getPlayerName(playerid) + " used /lights on.");
            }
            else if( option == "off" )
            {
                setVehicleLightState(id, false);
                log( getPlayerName(playerid) + " used /lights off.");
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [OPTION]!", colorError[0], colorError[1], colorError[2] );
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
        }    
    }
}
);

addCommandHandler( "open", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /open [PART].", colorError[0], colorError[1], colorError[2] );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Options are: hood | trunk", colorInfo[0], colorInfo[1], colorInfo[2] );
        return 1;
    }
    else {
        local option = vargv[0].tostring();
        if( isPlayerInVehicle( playerid ) )
        {
            local id = getPlayerVehicle(playerid);
            if( option == "hood" )
            {
                setVehiclePartOpen( id, VEHICLE_PART_HOOD, true );
                log( getPlayerName(playerid) + " used /open hood.");
            }
            else if( option == "trunk" )
            {
                setVehiclePartOpen( id, VEHICLE_PART_TRUNK, true );
                log( getPlayerName(playerid) + " used /open trunk.");
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [OPTION]!", colorError[0], colorError[1], colorError[2] );
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
        }    
    }
}
);

addCommandHandler( "close", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /close [PART].", colorError[0], colorError[1], colorError[2] );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Options are: hood | trunk", colorInfo[0], colorInfo[1], colorInfo[2] );
        return 1;
    }
    else {
        local option = vargv[0].tostring();
        if( isPlayerInVehicle( playerid ) )
        {
            local id = getPlayerVehicle(playerid);
            if( option == "hood" )
            {
                setVehiclePartOpen( id, VEHICLE_PART_HOOD, false );
                log( getPlayerName(playerid) + " used /close hood.");
            }
            else if( option == "trunk" )
            {
                setVehiclePartOpen( id, VEHICLE_PART_TRUNK, false );
                log( getPlayerName(playerid) + " used /close trunk.");
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [OPTION]!", colorError[0], colorError[1], colorError[2] );
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
        }    
    }
}
);

addCommandHandler( "taxi", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /taxi [OPTION].", colorError[0], colorError[1], colorError[2] );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Options are: on | off", colorInfo[0], colorInfo[1], colorInfo[2] );
        return 1;
    }
    else {
        local id = getPlayerVehicle(playerid);
        local option = vargv[0].tostring();
        local model = getVehicleModel ( getPlayerVehicle ( playerid ) );
        if( isPlayerInVehicle( playerid ) )
        {
            if(model == 24 || 33)
            {
                if( option == "on" )
                {
                    setTaxiLightState(id, true);
                    log( getPlayerName(playerid) + " used /taxi on for model " + model + ".");
                }
                else if( option == "off" )
                {
                    setTaxiLightState(id, false);
                    log( getPlayerName(playerid) + " used /taxi off for model " + model + ".");
                }
                else {
                    sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [OPTION]!", colorError[0], colorError[1], colorError[2] );
                }
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a taxi.", colorError[0], colorError[1], colorError[2] );
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
        }
    }
}
);

addCommandHandler( "plates", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /plates [TEXT].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local plates = vargv[0].tostring();    
        if( isPlayerInVehicle( playerid ) )
        {
            local vehicleid = getPlayerVehicle( playerid );
            setVehiclePlateText( vehicleid, plates );
            log( getPlayerName(playerid) + " used /plates " + plates + ".");
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
        }
    }        
}
);

addCommandHandler( "paint", function( playerid, ... ) {
    if(vargv.len() != 6)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /paint [RGB].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local r1 = vargv[0].tointeger(); 
        local g1 = vargv[1].tointeger(); 
        local b1 = vargv[2].tointeger(); 
        local r2 = vargv[3].tointeger(); 
        local g2 = vargv[4].tointeger(); 
        local b2 = vargv[5].tointeger();   
        if( isPlayerInVehicle( playerid ) )
        {
            if( isNumeric(r1) ||  isNumeric(r2) ||  isNumeric(g1) ||  isNumeric(g2) ||  isNumeric(b1) ||  isNumeric(b2) )
            {
                local vehicleid = getPlayerVehicle( playerid );
                setVehicleColour(vehicleid, r1.tointeger(), g1.tointeger(), b1.tointeger(), r2.tointeger(), g2.tointeger(), b2.tointeger());
                log( getPlayerName(playerid) + " used /paint " + r1 + " " + g1 + " " + b1 + " " + r2 + " " + g2 + " " + b2 + ".");
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
        }
    }
}
);

addCommandHandler( "dirt", function( playerid ) {
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        setVehicleDirtLevel( vehicleid, 1.0 );
        log( getPlayerName(playerid) + " used /dirt.");
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
    }
}
);

addCommandHandler( "tune", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /tune [1-3].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local amount = vargv[0].tostring(); 
        if( isPlayerInVehicle( playerid ) )
        {
            if(isNumeric(amount))
            {
                if( amount.tointeger() < 4 && 0 < amount.tointeger() )
                {   
                    local vehicleid = getPlayerVehicle( playerid );
                    setVehicleTuningTable( vehicleid, amount.tointeger() );
                    setVehicleWheelTexture( vehicleid, 0, 11 );
                    setVehicleWheelTexture( vehicleid, 1, 11 );
                    log( getPlayerName(playerid) + " used /tune " + amount + ".");
                }
                else {
                    sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Tune ID's: 1-3.", colorError[0], colorError[1], colorError[2] );
                }
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
        }
    }
}
);

addCommandHandler( "repair", function( playerid ) {
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        repairVehicle( vehicleid );
        log( getPlayerName(playerid) + " used /repair.");
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
    }
}
);

addCommandHandler( "wheels", function( playerid, ... ) {
    if(vargv.len() != 2)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /wheels [0-1] [ID].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local whe = vargv[0].tostring(); 
        local id = vargv[1].tostring();
        if( isPlayerInVehicle( playerid ) )
        {
            if( isNumeric(whe) || isNumeric(id) )
            {
                if( whe.tointeger() < 2 && -1 < whe.tointeger() )
                {
                    if( id.tointeger() < 15 && -1 < id.tointeger() )
                    {
                        local vehicleid = getPlayerVehicle( playerid );
                        setVehicleWheelTexture( vehicleid, whe.tointeger(), id.tointeger() );
                        log( getPlayerName(playerid) + " used /wheels " + whe + " " + id + "." );
                    }
                    else {
                        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Wheel ID's: 0-14.", colorError[0], colorError[1], colorError[2] );
                    }
                }
                else {
                    sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! First parameter defines front or rear wheels, 1 or 0.", colorError[0], colorError[1], colorError[2] );
                }
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
        }
    }
}
);

addCommandHandler( "heal", function( playerid ) {
    setPlayerHealth( playerid, spawnHealthAmount );
    sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Your total health is now 720.0", colorPositive[0], colorPositive[1], colorPositive[2] );
    log( getPlayerName(playerid) + " used /heal.");
}
);

addCommandHandler( "health", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /health [AMOUNT].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local amount = vargv[0].tostring(); 
        if( isNumeric(amount) )
        {
            setPlayerHealth( playerid, amount.tofloat() );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Your total health is now " + amount.tofloat() + ".", colorPositive[0], colorPositive[1], colorPositive[2] );
            log( getPlayerName(playerid) + " used /health " + amount + ".");
        }
    }
}
);

addCommandHandler( "model", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /model [ID].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local id = vargv[0].tostring(); 
        if( isNumeric(id) )
        {
            if( id.tointeger() < 155 && -1 < id.tointeger() )
            {
                setPlayerModel( playerid, id.tointeger() );
                log( getPlayerName(playerid) + " used /model " + id + ".");
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Character model ID's: 0-154.", colorError[0], colorError[1], colorError[2] );
            }
        }
    }
}
);

addCommandHandler( "randomize", function( playerid ) {
    setPlayerModel( playerid, (rand() % 155) );
    log( getPlayerName(playerid) + " used /randomize. Result model: " + getPlayerModel(playerid) + ".");
}
);

addCommandHandler( "unlock", function( playerid ) {
    togglePlayerControls( playerid, false );
    sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Restoring controls.", colorPositive[0], colorPositive[1], colorPositive[2] );
    log( getPlayerName(playerid) + " used /unlock.");
    return 1;

}
);

addCommandHandler( "lock", function( playerid ) {
    togglePlayerControls( playerid, true );
    sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Restoring controls.", colorPositive[0], colorPositive[1], colorPositive[2] );
    log( getPlayerName(playerid) + " used /lock.");
    return 1;

}
);

addCommandHandler( "goto", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /goto [ID].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local other = vargv[0].tostring(); 
        if( isNumeric(other) )
        {
            if(isPlayerInVehicle(other.tointeger() ) )
            {
                local vehicleid = getPlayerVehicle(other.tointeger() );
                local pos = getVehiclePosition( vehicleid );
                setPlayerPosition( playerid, pos[0] + 2.0, pos[1], pos[2] );
                sendPlayerMessage(other.tointeger(), serverMsgPrefix + ": " + getPlayerName(playerid) + " spawned at your location.", colorPositive[0], colorPositive[1], colorPositive[2] );
                log( getPlayerName(playerid) + " used /goto " + other +".");
            }
            else
            {
                local pos = getPlayerPosition( other.tointeger() );
                setPlayerPosition( playerid, pos[0] + 2.0, pos[1], pos[2] );
                sendPlayerMessage(other.tointeger(), serverMsgPrefix + ": " + getPlayerName(playerid) + " spawned at your location.", colorPositive[0], colorPositive[1], colorPositive[2] );
                log( getPlayerName(playerid) + " used /goto " + other +".");
            }
        }
    }
}
);

addCommandHandler( "weapon", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /weapon [ID].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local id = vargv[0].tostring();   
        if(isNumeric(id))
        if( id.tointeger() < 22 && 1 < id.tointeger() )
        {
            if (allowWeapons)
            {
                givePlayerWeapon(playerid, id.tointeger(), 999 );
                log( getPlayerName(playerid) + " used /weaapon " + id + ".");
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Weapons aren't allowed in this server.", colorError[0], colorError[1], colorError[2] );
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Weapon ID's: 2-21.", colorError[0], colorError[1], colorError[2] );
        }
    }
}
);

addCommandHandler( "reload", function( playerid ) {
    local id = getPlayerWeapon(playerid);
    givePlayerWeapon(playerid, id.tointeger(), spawnWeaponAmmo );
    sendPlayerMessage(playerid,serverMsgPrefix + ": " + "The ammunition of your currently equipped weapon has been reloaded!", colorPositive[0], colorPositive[1], colorPositive[2] );
    log( getPlayerName(playerid) + " used /reload.");
}
);

addCommandHandler( "action", function( playerid, ... ) {
	if(vargv.len() != 1)
	{
		sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /action [ACTION].", colorError[0], colorError[1], colorError[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action pocket - A hand in a pocket", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action pockets - Hands in pockets", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action fold - Fold hands", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action up - Surrender, hands up", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action hotdog - ...hotdog", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action hurt", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action sad", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action suitcase", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action ketchup", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action drunk", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action crossed - Cold (Winter)", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action down - Cold (Winter)", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action coat - Cold (Winter)", colorPositive[0], colorPositive[1], colorPositive[2] );
		sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/action collar - Cold (Winter)", colorPositive[0], colorPositive[1], colorPositive[2] );
		return 1;
	}
	else {
		local action = vargv[0].tostring();
		if( isPlayerInVehicle( playerid ) )
		{
			sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +"You have to leave your vehicle first.", colorError[0], colorError[1], colorError[2] );
		}
		else {
			if( action == "pocket" )
			{
				setPlayerAnimStyle(playerid, "common", "ManOneHandInPocket");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "pockets" )
			{
				setPlayerAnimStyle(playerid, "common", "ManHandsInPockets");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "fold" )
			{
				setPlayerAnimStyle(playerid, "common", "ManHandsFolded");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "hotdog" )
			{
				setPlayerAnimStyle(playerid, "common", "ManWalkHotdog");
				setPlayerHandModel(playerid, 1, 48)
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "hurt" )
			{
				setPlayerAnimStyle(playerid, "common", "Injury");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "sad" )
			{
				setPlayerAnimStyle(playerid, "common", "OldMan");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "suitcase" )
			{
				setPlayerAnimStyle(playerid, "common", "ManBigSuitcase");
				setPlayerHandModel(playerid, 1, 46)
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "ketchup" )
			{
				setPlayerAnimStyle(playerid, "common", "ManUmbrellaOpen");
				setPlayerHandModel(playerid, 1, 79)
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "drunk" )
			{
				setPlayerAnimStyle(playerid, "common", "Drunk");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "up" )
			{
				setPlayerAnimStyle(playerid, "common", "ManHandsUp");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "crossed" )
			{
				setPlayerAnimStyle(playerid, "common", "ManWinterCrossHands");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "down" )
			{
				setPlayerAnimStyle(playerid, "common", "ManWinterHandsDown");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "coat" )
			{
				setPlayerAnimStyle(playerid, "common", "ManWinterHoldingCoat");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else if( action == "collar" )
			{
				setPlayerAnimStyle(playerid, "common", "WomanWinterHandCollar");
				log( getPlayerName(playerid) + " used /action " + action + ".");
			}
			else {
				sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [ACTION]!", colorError[0], colorError[1], colorError[2] );
			}
		}
	}
}
);


function pm(...) {
    local playerid = vargv[0];
    if(vargv.len() > 2)
    {
        local targetid = vargv[1];
        if(isPlayerConnected(targetid.tointeger()))
        {
            if(isNumeric(targetid))
            {
                local toplayer = targetid.tointeger();
                local msg = "";
                for (local i = 2; i < vargv.len(); i++)
                {
                    msg = msg + " " + vargv[i];
                }
                sendPlayerMessage(toplayer, "PM from (" + playerid + ") " + getPlayerName(playerid) + ": " + msg, colorPastel[0], colorPastel[1], colorPastel[2] );
                sendPlayerMessage(playerid, "PM sent to (" + toplayer + ") " + getPlayerName(toplayer) + ": " + msg, colorPastel[0], colorPastel[1], colorPastel[2] );
                log( "PM from " + playerid + " to " + toplayer + ": " + msg + " | END |");
            }
        }
        else
        {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid ID.", colorError[0], colorError[1], colorError[2] );
        }
    }
    else
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /pm [ID] [MESSAGE].", colorError[0], colorError[1], colorError[2] );
    }
    return true;
}
addCommandHandler("pm", pm);

function s(...) {
    local playerid = vargv[0].tointeger();
    if(vargv.len() == 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /s [MESSAGE].", colorError[0], colorError[1], colorError[2] ); 
        return 1;
    }
    if(isPlayerConnected(playerid))
    {
        local msg = "";
        local i;
        local plypos, userpos, distance;
        plypos = getPlayerPosition(playerid);
        for(i = 1; i < vargv.len(); i++) msg = msg+" "+vargv[i];
        for(i = 0; i < getMaxPlayers(); i++)
        log( playerid + "said: " + msg + "| END |");
        {
            if(isPlayerConnected(i))
            {
                userpos = getPlayerPosition(i);
                distance = getDistanceBetweenPoints3D( userpos[0], userpos[1], userpos[2], plypos[0], plypos[1], plypos[2] );
                if(distance < 15)
                {
                    sendPlayerMessage(i,getPlayerName(playerid) + " said: " + msg, colorPastel[0], colorPastel[1], colorPastel[2] );
                    log( getPlayerName(playerid) + " used /s. Text: " + msg + " |.");
                }
            }
        }
    }
}
addCommandHandler("s", s);

addCommandHandler( "mypos", function( playerid ) {
    local ppos = getPlayerPosition(playerid);
    sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Your current coordinates are " + ppos[0] +", " + ppos[1] + ", " + ppos[2] + ".", colorPositive[0], colorPositive[1], colorPositive[2] );
    log ( getPlayerName(playerid) + " coordinates are " + ppos[0] +", " + ppos[1] + ", " + ppos[2] + "")
}
);

addCommandHandler( "tele", function( playerid, ... ) {
    if(vargv.len() != 3)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /tele [COORDINATE X] [COORDINATE Y] [COORDINATE Z].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        if( isNumeric( vargv[0] ) && isNumeric( vargv[1] ) && isNumeric( vargv[2] ) )
        {
            local x = vargv[0].tofloat(); 
            local y = vargv[1].tofloat(); 
            local z = vargv[2].tofloat();
            {
                setPlayerPosition(playerid, x.tofloat(), y.tofloat(), z.tofloat() );
                log( getPlayerName(playerid) + " used /tele to " + x +", " + y + ", " + z + ".");
            }
        }
    }
}
);

addCommandHandler( "resetpaint", function ( playerid ) {
    if  ( isPlayerInVehicle ( playerid ) )
    {
        local model = getVehicleModel ( getPlayerVehicle ( playerid ) );
        if(model == 42 )
        {
            setVehicleColour ( getPlayerVehicle ( playerid ), 250, 250, 250, 0, 0, 0 );
            log( getPlayerName(playerid) + " used /resetpaint on model " + model + ".");
        }
        if(model == 51 )
        {
            setVehicleColour ( getPlayerVehicle ( playerid ), 0, 0, 0, 100, 100, 100 );
            log( getPlayerName(playerid) + " used /resetpaint on model " + model + ".");
        }
    }
}
);

addCommandHandler( "vehicleinfo", function( playerid ) {
    if  ( isPlayerInVehicle ( playerid ) )
    {
        local id = getPlayerVehicle(playerid);
        local col = getVehicleColour(id);

        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "-Vehicle information-", colorPositive[0], colorPositive[1], colorPositive[2] );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "ID: " + id, colorPositive[0], colorPositive[1], colorPositive[2] );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "MODEL: " + getVehicleModel(id), colorPositive[0], colorPositive[1], colorPositive[2] );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "PLATES: " + getVehiclePlateText(id), colorPositive[0], colorPositive[1], colorPositive[2] );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "TUNINGLEVEL: " + getVehicleTuningTable(id), colorPositive[0], colorPositive[1], colorPositive[2] );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "Color 1 R: " + col[0], colorPositive[0], colorPositive[1], colorPositive[2] );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "Color 1 G: " + col[1], colorPositive[0], colorPositive[1], colorPositive[2] );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "Color 1 B: " + col[2], colorPositive[0], colorPositive[1], colorPositive[2] );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "Color 2 R: " + col[3], colorPositive[0], colorPositive[1], colorPositive[2] );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "Color 2 G: " + col[4], colorPositive[0], colorPositive[1], colorPositive[2] );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "Color 2 B: " + col[5], colorPositive[0], colorPositive[1], colorPositive[2] );
        log( getPlayerName(playerid) + " used /vehicleinfo.");
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", colorError[0], colorError[1], colorError[2] );
    }
}
);

addCommandHandler("cc", function( playerid ) {
    for( local i = 0; i <= 15; ++i )
    sendPlayerMessage(playerid, " " );
    log( getPlayerName(playerid) + " used /cc.");
}
);

addCommandHandler( "automsg", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /automsg [OPTION].", colorError[0], colorError[1], colorError[2] );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Options are: enable | disable", colorInfo[0], colorInfo[1], colorInfo[2] );
        return 1;
    }
    else {
        local area = vargv[0].tostring();
        if( area == "enable" )
        {
            MsgAccess[playerid] = 1;
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You will now receive automatic server messages.", 175, 255, 45 ); 
            log( getPlayerName(playerid) + " enabled AutoMsg!");
        }
        else if( area == "disable" )
        {
            MsgAccess[playerid] = 0;
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You will no longer receive automatic server messages.", 175, 255, 45 ); 
            log( getPlayerName(playerid) + " disabled AutoMsg!");

        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [OPTION]!", colorError[0], colorError[1], colorError[2] );
        }
    }
}
);

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// WEATHER SYSTEM BELOW. IS IT SAFE TO EDIT THESE? ©Rolandd
// [ ] YES
// [x] NO

WEATHERS <- {
    SUMMER = [
    [0, 2, ["DT_RTRclear_day_nigh", "DT07part04night_bordel", "DTFreerideNight", "DT14part11", "DT11part05", "DT_RTRrainy_day_night", "DT10part03Subquest", "DT_RTRfoggy_day_night"] ],

    [3, 5, ["DT_RTRclear_day_early_morn1", "DT_RTRfoggy_day_early_morn1", "DT_RTRrainy_day_early_morn"] ],

    [6, 9, ["DT_RTRclear_day_early_morn2", "DT_RTRclear_day_morning", "DT_RTRrainy_day_morning", "DT_RTRfoggy_day_morning"] ],

    [10, 10, ["DTFreeRideDay", "DT06part03", "DTFreeRideDayRain", "DT11part01", "DT_RTRfoggy_day_noon"] ],
    [11, 11, ["DT07part01fromprison", "DT13part01death", "DT09part1VitosFlat", "DT_RTRclear_day_noon", "DT06part01", "DT06part02", "DT11part02"] ],
    [12, 12, ["DT07part02dereksubquest", "DT08part01cigarettesriver", "DT09part2MalteseFalcone", "DT14part1_6", "DT_RTRrainy_day_noon", "DT_RTRfoggy_day_afternoon"] ],
    [13, 13, ["DT_RTRclear_day_afternoon", "DT10part02Roof", "DT09part3SlaughterHouseAfter", "DT_RTRrainy_day_afternoon", "DT_RTRfoggy_day_afternoon"] ],
    [14, 15, ["DT09part4MalteseFalcone2", "DT08part02cigarettesmill", "DT12_part_all", "DT15", "DT15end", "DT15_interier"] ],
    [16, 17, ["DT13part02", "DT_RTRclear_day_late_afternoon", "DT01part01sicily_svit" "DT_RTRrainy_day_late_afternoon", "DT11part03", "DT_RTRfoggy_day_late_afternoon"] ],
    [18, 18, ["DT08part03crazyhorse", "DT07part03prepadrestaurcie", "DT_RTRrainy_day_evening", "DT_RTRfoggy_day_late_afternoon"] ],
    [19, 19, ["DT05part06Francesca", "DT10part03Evening", "DT14part7_10", "DT11part04", "DT_RTRfoggy_day_evening"] ],
    [20, 23, ["DT_RTRclear_day_evening", "DT08part04subquestwarning", "DT_RTRclear_day_late_even", "DT_RTRrainy_day_late_even", "DT_RTRfoggy_day_late_even", "DT01part02sicily"] ],
    ],

    WINTER = [
    [0, 7, ["DTFreeRideNightSnow", "DT04part02"] ],
    [8, 11, ["DT05part01JoesFlat", "DT03part01JoesFlat", "DTFreeRideDaySnow"] ],
    [12, 13, ["DT05part02FreddysBar", "DTFreeRideDayWinter", "DT05part04Distillery", "DT04part01JoesFlat"] ],
    [14, 15, ["DT02part01Railwaystation", "DT05part03HarrysGunshop", "DT05part05ElGreco"] ],
    [16, 17, ["DT02part02JoesFlat", "DT02part04Giuseppe", "DT03part02FreddysBar"] ],
    [18, 20, ["DT05Distillery_inside", "DT02part05Derek", "DT02part03Charlie"] ],
    [21, 23, ["DT02NewStart1", "DT03part03MariaAgnelo", "DT02NewStart2", "DT03part04PriceOffice"] ],
    ]
};


playerWeather <- array(MAX_PLAYERS, 0);

function Time() {
    WEATHER_CHANGE_TRIGGER--;

    GLOBAL_SECONDS++;

    if(GLOBAL_SECONDS >= 60){
        GLOBAL_MINUTES++;
        GLOBAL_SECONDS = 0;
    }
    if (GLOBAL_MINUTES >= 60) {
        GLOBAL_HOURS++;
        GLOBAL_MINUTES = 0;
    }
    if (GLOBAL_HOURS >= 24) {
        GLOBAL_HOURS = 0;
        GLOBAL_MINUTES = 0;
    }

    GLOBAL_TIME = format("%02i:%02i", GLOBAL_HOURS, GLOBAL_MINUTES);



    if (WEATHER_CHANGE_TRIGGER <= 0) {
        local weathers = (SERVER_IS_SUMMER) ? WEATHERS.SUMMER : WEATHERS.WINTER;

        for (local i = 0; i < weathers.len(); i++) {
            if (GLOBAL_HOURS >= weathers[i][0] && GLOBAL_HOURS <= weathers[i][1]) {
                local randWeather = weathers[i][2][random(0, weathers[i][2].len()-1)];
                setWeather(randWeather);
                SERVER_WEATHER = randWeather;

                for (local p = 0; p < MAX_PLAYERS; p++) {
                    if (isPlayerConnected(p)) {
                        playerWeather[p] = SERVER_WEATHER;
                    }
                }
                WEATHER_CHANGE_TRIGGER = random(20*60, 60*60);

                break;
            }
        }
    }



    for (local i = 0; i < MAX_PLAYERS; i++) {
        if (isPlayerConnected(i)) {
            if (playerWeather[i] != SERVER_WEATHER) {
                playerWeather[i] = SERVER_WEATHER;

                setWeather(SERVER_WEATHER);
            }

            triggerClientEvent(i, "setTime", GLOBAL_TIME);  
        }
    }
}

// ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
// ADMIN SYSTEM BELOW. IS IT SAFE TO EDIT THESE?
// [ ] YES
// [x] NO

addCommandHandler( "login", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /login [PASSWORD].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local password = vargv[0].tostring();   
        if(Logged[playerid] == 0)
        {
            if( password == rconPassword)
            {
                if( getPlayerSerial( playerid ) == adminSerial)
                {
                    Admin[playerid] = 1;
                    Logged[playerid] = 1;
                    sendPlayerMessage(playerid, "RCON: Logged in succesfully.", colorPositive[0], colorPositive[1], colorPositive[2] );
                    log( "RCON: " + getPlayerName(playerid) + " logged into RCON");
                }
                else {
                    sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", colorError[0], colorError[1], colorError[2] );
                }
            }
            else
            {
                sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Invalid entry.", colorPositive[0], colorPositive[1], colorPositive[2] );
            }
        }
        else
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You are already logged in!", colorError[0], colorError[1], colorError[2] );
        }
    }
}
);

addCommandHandler( "logout", function( playerid ) {
    if(Logged[playerid] == 1)
    {
        Admin[playerid] = 0;
        Logged[playerid] = 0;
        sendPlayerMessage(playerid, "RCON: Logged out succesfully.", colorPositive[0], colorPositive[1], colorPositive[2] );
        log( "RCON: " + getPlayerName(playerid) + " logged out from RCON.");
    }
    else
    {
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "..but you haven't even logged in yet.", colorError[0], colorError[1], colorError[2] );
    }
}
);

addCommandHandler( "ahelp", function( playerid ) {
    if(Logged[playerid] == 1)
    {
        sendPlayerMessage(playerid, "/logout", 255, 204, 229);
        sendPlayerMessage(playerid, "/kick [ID]", 255, 204, 229);
        sendPlayerMessage(playerid, "/ban [ID] ", 255, 204, 229);
        sendPlayerMessage(playerid, "/kill [ID]", 255, 204, 229);
    }
    else
    {
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", colorError[0], colorError[1], colorError[2] );
    }
}
);

addCommandHandler( "kick", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /kick [ID].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local other = vargv[0].tostring();   
        if( isNumeric(other) )
        {
            if(Logged[playerid] == 1)
            {
                sendPlayerMessageToAll(serverMsgPrefix + ": " + getPlayerName(other.tointeger()) + " was kicked by " + getPlayerName(playerid) + ".", colorPositive[0], colorPositive[1], colorPositive[2] );
                local kick = kickPlayer(other.tointeger());
                log( getPlayerName( playerid ) + " kicked " + getPlayerName(other.tointeger()) + ".");

            }
            else
            {
                sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", colorError[0], colorError[1], colorError[2] );
            }
        }
    }
}
);

addCommandHandler( "ban", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /kick [ID].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local other = vargv[0].tostring();   
        if( isNumeric(other) )
        {
            if(Logged[playerid] == 1)
            {
                sendPlayerMessageToAll(serverMsgPrefix + ": " + getPlayerName(other.tointeger()) + " was kicked by " + getPlayerName(playerid) + ".", colorPositive[0], colorPositive[1], colorPositive[2] );
                banPlayer( other.tointeger(), playerid, 0,  "Used /ban");
                log( getPlayerName( playerid ) + " banned " + getPlayerName(other.tointeger()) + ".");

            }
            else
            {
                sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", colorError[0], colorError[1], colorError[2] );
            }
        }
    }
}
);

addCommandHandler( "kill", function( playerid, ... ) {
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Usage: /kill [ID].", colorError[0], colorError[1], colorError[2] );
        return 1;
    }
    else {
        local other = vargv[0].tostring();   
        if( isNumeric(other) )
        {
            if(Logged[playerid] == 1)
            {
                setPlayerHealth(other.tointeger(), 0.0 );
                sendPlayerMessage(other.tointeger(), serverMsgPrefix + ": " + getPlayerName(playerid) + "(Admin) has killed you.", colorPositive[0], colorPositive[1], colorPositive[2] );
                sendPlayerMessage(playerid, "RCON: You killed " + getPlayerName(other.tointeger()) + " succesfully.", colorPositive[0], colorPositive[1], colorPositive[2] );
            }
            else
            {
                sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", colorError[0], colorError[1], colorError[2] );
            }
        }
    }
}
);
