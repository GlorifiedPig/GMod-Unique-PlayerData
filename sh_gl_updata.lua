
--[[
    A rewrite of the SetPData library to work with SteamID64s.
    https://github.com/GlorifiedPig/gmod-unique-playerdata

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

local updataVersion = 1.0

if !GlorifiedUPData or GlorifiedUPData.Version < updataVersion then

    GlorifiedUPData = { Version = updataVersion }

    local plyMeta = FindMetaTable( "Player" )
    if( !plyMeta ) then return end

    local sql_Query = sql.Query

    if ( !sql.TableExists( "glorifiedupdata" ) ) then
        sql_Query( "CREATE TABLE IF NOT EXISTS glorifiedupdata ( key TEXT NOT NULL PRIMARY KEY, value TEXT );" )
    end

    function plyMeta:SetUPData( key, value )
        key = Format( "%s[%s]", self:SteamID64(), key )
        sql_Query( "REPLACE INTO glorifiedupdata ( key, value ) VALUES ( " .. SQLStr( key ) .. ", " .. SQLStr( value ) .. " )" )
    end

    function plyMeta:GetUPData( key, default )
        key = Format( "%s[%s]", self:SteamID64(), key )
        local val = sql.QueryValue( "SELECT value FROM glorifiedupdata WHERE key = " .. SQLStr( key ) .. " LIMIT 1" )
        
        if ( val == nil ) then return default end
        return val
    end

end
