--[[ If you arent using the loadstring then add
getgenv().apikey = "OAuth token Here"
To the begining of the script

or just use the loadstring:

getgenv().apikey = "OAuth token here"
loadstring(game:HttpGet("https://raw.githubusercontent.com/SeusTheABG/ROBLOX/main/Scripts/Spotify%20Viewer.lua"))()

{ Get OAuth token here: }
https://developer.spotify.com/console/get-users-currently-playing-track

{ Check these boxes: }
https://cdn.discordapp.com/attachments/822581426364874824/962062001247502446/unknown.png
]]--

if (not apikey) then
	game.Players.LocalPlayer:Kick("API Key not detected! Did you follow instructions correctly?") 
end

local requests = {
	["CurrentlyPlaying"] = {
		Url = "https://api.spotify.com/v1/me/player/currently-playing",
		Method = "GET",
		Headers = {
			["Accept"] = "application/json",
			["Authorization"] = "Bearer " .. apikey,
			["Content-Type"] = "application/json"
		}
	},
}

local CurrentAlbumCover = Drawing.new("Image")

local startergui = game:GetService("StarterGui")

local notify = function(title, message, duration)
	startergui:SetCore("SendNotification", {
		Title = title,
		Text = message,
		Duration = duration,
		Button1 = "OK"
	})
end

notify("ROBLOX Spotify", "Successfully loaded!\nPress Home to open and close!", 5)

local SpotifyMusic = Instance.new("ScreenGui")
local CurrentlyPlaying = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Artist = Instance.new("TextLabel")
local Cover = Instance.new("Frame")

SpotifyMusic.Name = "SpotifyMusic"
SpotifyMusic.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
SpotifyMusic.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

CurrentlyPlaying.Name = "CurrentlyPlaying"
CurrentlyPlaying.Parent = SpotifyMusic
CurrentlyPlaying.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CurrentlyPlaying.BorderSizePixel = 0
CurrentlyPlaying.Position = UDim2.new(0, 150, 0, -36)
CurrentlyPlaying.Size = UDim2.new(0, 250, 0, 35)

Title.Name = "Title"
Title.Parent = CurrentlyPlaying
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0.129999995, 0, 0, 0)
Title.Size = UDim2.new(0.869999945, 0, 0.5, 0)
Title.Font = Enum.Font.SourceSans
Title.Text = "Title"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14.000
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Bottom

Artist.Name = "Artist"
Artist.Parent = CurrentlyPlaying
Artist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Artist.BackgroundTransparency = 1.000
Artist.Position = UDim2.new(0.129999995, 0, 0.485714287, 0)
Artist.Size = UDim2.new(0.869999945, 0, 0.5, 0)
Artist.Font = Enum.Font.SourceSans
Artist.Text = "Artist"
Artist.TextColor3 = Color3.fromRGB(200, 200, 200)
Artist.TextSize = 14.000
Artist.TextXAlignment = Enum.TextXAlignment.Left
Artist.TextYAlignment = Enum.TextYAlignment.Top

Cover.Name = "Cover"
Cover.Parent = CurrentlyPlaying
Cover.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Cover.BorderSizePixel = 0
Cover.Position = UDim2.new(0, 4, 0, 4)
Cover.Size = UDim2.new(0, 25, 0, 25)

-- Scripts:

CurrentAlbumCover.Visible = true
CurrentAlbumCover.Size = Vector2.new(25, 25)
CurrentAlbumCover.Position = Vector2.new(CurrentlyPlaying.AbsolutePosition.X + 4, CurrentlyPlaying.AbsolutePosition.Y + 40)

local function EQQJ_fake_script()
	local script = Instance.new('LocalScript', CurrentlyPlaying)

    local http = game:GetService("HttpService")
	local artistLabel = script.Parent.Artist
	local titleLabel = script.Parent.Title
	local previousSong = nil
	while wait() do
		local resp = syn.request(requests["CurrentlyPlaying"])
	
		if (resp.Body == "") then
			artistLabel.Text = "N/A"
			titleLabel.Text = "Nothing is currently playing!"
			CurrentAlbumCover.Data = ""
			print(resp.Body)
	
			continue
		end
	
		currentSong = http:JSONDecode(resp.Body)
	
		if (currentSong.error) then
			notify("Oh no! An error occurred!", currentSong.error.message, 0.5)
			wait(3)
			continue
		elseif ((currentSong.item == nil) or (previousSong and previousSong == currentSong.item.name)) then
			continue
		elseif (previousSong ~= currentSong.item.name) then
			notify("Now Playing!", currentSong.item.name .. "\nBy " .. currentSong.item.artists[1].name, 0.5)
	
			previousSong = currentSong.item.name
		end
	
		local artists = currentSong.item.artists
		local artistString = artists[1].name
	
		for i, v in next, artists do
			if (v.name == artists[1].name) then
				continue
			end
	
			artistString = artistString .. ", " .. v.name
		end
	
		CurrentAlbumCover.Data = game:HttpGet(tostring(currentSong.item.album.images[3].url))
		artistLabel.Text = artistString
		titleLabel.Text = currentSong.item.name
	
		print("playing " .. currentSong.item.name)
	end
	
	artistLabel.Text = "N/A"
	titleLabel.Text = "Nothing is currently playing!"
	CurrentAlbumCover.Data = ""
	print(resp.Body)
end
coroutine.wrap(EQQJ_fake_script)()
