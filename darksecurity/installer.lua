-- Get terminal dimensions
x, y = term.getSize()

-- Professional header function
function header(text, lText, rText)
  -- Title bar
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.setCursorPos(1, 1)
  term.write(string.rep(" ", x))
  term.setCursorPos(math.floor((x - #text) / 2) + 1, 1)
  term.write(text)
  if lText then
    term.setCursorPos(1, 1)
    term.setTextColor(colors.lightBlue)
    term.write(lText)
  end
  if rText then
    term.setCursorPos(x - #rText + 1, 1)
    term.setTextColor(colors.lightBlue)
    term.write(rText)
  end
  
  -- Menu bar
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.black)
  term.setCursorPos(1, 2)
  term.write(string.rep(" ", x))
  term.setCursorPos(2, 2)
  term.write("Install")
  term.setCursorPos(12, 2)
  term.write("Setup")
  term.setCursorPos(22, 2)
  term.write("Options")
  
  -- Separator
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.gray)
  term.setCursorPos(1, 3)
  term.write(string.rep("-", x))
end

-- Professional footer function
function footer()
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  term.setCursorPos(1, y)
  term.write(string.rep(" ", x))
  term.setCursorPos(1, y)
  term.setTextColor(colors.green)
  term.write("[ONLINE]")
  term.setCursorPos(11, y)
  term.setTextColor(colors.blue)
  term.write("Installer")
  term.setCursorPos(x-8, y)
  term.setTextColor(colors.orange)
  term.write("ID:" .. os.getComputerID())
end

-- Reset colors function
function resetColors()
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
end

term.clear()
header("DARKPROGRAMS INSTALLER", "v1.0", "SETUP")
footer()
resetColors()

term.setCursorPos(2, 5)
term.setTextColor(colors.cyan)
term.write("* SYSTEM CHECK *")
term.setCursorPos(2, 7)
term.setTextColor(colors.yellow)
term.write("> Checking HTTP status...")
sleep(0.5)

if http then
  term.setCursorPos(2, 8)
  term.setTextColor(colors.green)
  term.write("+ HTTP is enabled!")
else
  term.setCursorPos(2, 8)
  term.setTextColor(colors.red)
  term.write("- HTTP is not enabled")
  term.setCursorPos(2, 9)
  term.write("- Please enable HTTP in config")
  resetColors()
  return
end
sleep(1)
programs = {}

term.clear()
header("PROGRAM SELECTION", "v1.0", "SETUP")
footer()
resetColors()

term.setCursorPos(2, 5)
term.setTextColor(colors.white)
term.write("=== AVAILABLE PROGRAMS ===")
term.setCursorPos(2, 7)
term.setTextColor(colors.yellow)
term.write("> [1] Security Server")
term.setCursorPos(2, 8)
term.write("> [2] Security Client")

term.setCursorPos(2, 10)
term.setTextColor(colors.cyan)
term.write("Select program type:")
term.setCursorPos(2, 11)
term.setTextColor(colors.white)
repeat
  term.setCursorPos(2, 12)
  term.write("Server/Client: ")
  term.clearLine()
  term.setCursorPos(17, 12)
  installAnswer = read()
until ((installAnswer == "Server") or (installAnswer == "Client") or (installAnswer == "server") or (installAnswer == "client"))
	
if installAnswer == "Server" then
  table.insert(programs, "server")
elseif installAnswer == "Client" then
  table.insert(programs, "client")
elseif installAnswer == "server" then
  table.insert(programs, "server")
elseif installAnswer == "client" then
  table.insert(programs, "client")
end

term.setCursorPos(2, 14)
term.setTextColor(colors.cyan)
term.write("Installation path:")
term.setCursorPos(2, 15)
term.setTextColor(colors.gray)
term.write("Default: / (Press Enter to use default)")
term.setCursorPos(2, 16)
term.setTextColor(colors.white)
term.write("Path: ")
pathAnswer = read()

if pathAnswer == "" then
  pathAnswer = "/"
end

term.clear()
header("DOWNLOADING PROGRAMS", "v1.0", "INSTALL")
footer()
resetColors()

term.setCursorPos(2, 5)
term.setTextColor(colors.white)
term.write("=== DOWNLOAD PROGRESS ===")
term.setCursorPos(2, 7)
term.setTextColor(colors.yellow)
term.write("> Fetching program versions...")

local status, getGit = pcall(http.get, "https://raw.githubusercontent.com/rservices/darkprograms/darkprograms/programVersions")
if not status then
  term.setCursorPos(2, 8)
  term.setTextColor(colors.red)
  term.write("- Failed to get program versions")
  term.setCursorPos(2, 9)
  term.write("- Error: ".. getGit)
  resetColors()
  return
end 
  
local getGit = getGit.readAll()
NVersion = textutils.unserialize(getGit)

term.setCursorPos(2, 8)
term.setTextColor(colors.green)
term.write("+ Version data retrieved")

for i = 1, #programs do
  term.setCursorPos(2, 9 + i)
  term.setTextColor(colors.yellow)
  term.write("> Downloading: "..programs[i])
  
  getGit = http.get(NVersion[programs[i]].GitURL)
  getGit = getGit.readAll()
  local file = fs.open(pathAnswer..programs[i], "w")
  file.write(getGit)
  file.close()
  
  term.setCursorPos(2, 9 + i)
  term.setTextColor(colors.green)
  term.write("+ Downloaded: "..programs[i])
  sleep(0.5)
end

term.setCursorPos(2, 12)
term.setTextColor(colors.cyan)
term.write("* All programs downloaded successfully *")

term.setCursorPos(2, 14)
term.setTextColor(colors.white)
term.write("=== STARTUP CONFIGURATION ===")
term.setCursorPos(2, 16)
term.setTextColor(colors.yellow)
term.write("Generate startup file for auto-launch?")
term.setCursorPos(2, 17)
term.setTextColor(colors.white)
repeat
  term.setCursorPos(2, 18)
  term.write("Y / N: ")
  term.clearLine()
  term.setCursorPos(9, 18)
  startupAnswer = read()
until ((startupAnswer == "Y") or (startupAnswer == "N") or (startupAnswer == "y") or (startupAnswer == "n"))

if startupAnswer == "Y" or startupAnswer == "y" then
  file = fs.open("startup", "w")
  file.write("shell.run(\"".. programs[1] .."\")")
  file.close()
  term.setCursorPos(2, 19)
  term.setTextColor(colors.green)
  term.write("+ Startup file created")
else
  term.setCursorPos(2, 19)
  term.setTextColor(colors.gray)
  term.write("- Startup file skipped")
end

term.clear()
header("INSTALLATION COMPLETE", "v1.0", "DONE")
footer()
resetColors()

term.setCursorPos(2, 8)
term.setTextColor(colors.green)
term.write("[SUCCESS] Installation completed successfully!")
term.setCursorPos(2, 10)
term.setTextColor(colors.white)
term.write("Thank you for choosing DarkPrograms")
term.setCursorPos(2, 11)
term.setTextColor(colors.gray)
term.write("for all your security needs.")

term.setCursorPos(2, 14)
term.setTextColor(colors.orange)
term.write("> System will restart in 3 seconds...")
sleep(3)
os.reboot()
