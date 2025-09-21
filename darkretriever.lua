Version = 2.12
x,y = term.getSize()

if not http then
  print("Herp derp, forget to enable http?")
  return
end

local function getUrlFile(url)
  local response = http.get(url)
  local contents = response.readAll()
  response.close()
  return contents
end

local function writeFile(filename, data)
  local file = fs.open(filename, "w")
  file.write(data)
  file.close()
end

local function cs()
  term.clear()
  term.setCursorPos(1,1)
end

local function tc(tcolor,bcolor)
  if term.isColor() then
    if tcolor then
      term.setTextColor(colors[tcolor])
    end
    if bcolor then
      term.setBackgroundColor(colors[bcolor])  
    end
  end
end

local function writeC(text,line)
  term.setCursorPos((x / 2) - (#text / 2),line)
  term.write(text)
end

term.oldWrite = term.write
function term.write(text)
  if not text then
    text = ""
  end
  term.oldWrite(text)
end

local function header(text, lText, rText)
  -- Title bar exactly like server
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.setCursorPos(1, 1)
  term.write(string.rep(" ", x))
  term.setCursorPos(math.floor((x - 15) / 2) + 1, 1)
  term.write("Package Manager")
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
  term.write("Browse")
  term.setCursorPos(12, 2)
  term.write("Download")
  term.setCursorPos(22, 2)
  term.write("Tools")
  term.setCursorPos(29, 2)
  term.write("Help")
  
  -- Separator
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.gray)
  term.setCursorPos(1, 3)
  term.write(string.rep(" ", x))
  
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
end

local function footer()
  -- Gray footer bar
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  term.setCursorPos(1, y)
  term.write(string.rep(" ", x))
  term.setCursorPos(x - 21, y)
  term.setTextColor(colors.green)
  term.write("BY RECKLESS-METRO.COM")
end

local function gitUpdate(ProgramName, Filename, ProgramVersion)
  if http then
    local status, getGit = pcall(http.get, "https://raw.githubusercontent.com/recklessmetro/darkprograms/darkprograms/programVersions")
    if not status then
      print("\nFailed to get Program Versions file.")
      print("Error: ".. getGit)
      return exit
    end 
    getGit = getGit.readAll()
    local NVersion = textutils.unserialize(getGit)
    if NVersion[ProgramName].Version > ProgramVersion then
      getGit = http.get(NVersion[ProgramName].GitURL)
      getGit = getGit.readAll()
      local file = fs.open(Filename, "w")
      file.write(getGit)
      file.close()
      return true
    end
  else
    return false
  end
end

cs()
print("Checking for updates...")
if gitUpdate("darkretriever", shell.getRunningProgram(), Version) == true then
  print("Update found and downloaded.")
  print("\nPlease run ".. shell.getRunningProgram() .. " again.")
  return exit
else
  print("Program up-to-date.")
end
sleep(1)

x, y = term.getSize()
cs()
write("-> Grabbing file...")
cat = getUrlFile("https://raw.githubusercontent.com/recklessmetro/darkprograms/darkprograms/programVersions")
cat = textutils.unserialize(cat)
write(" Done.")
sleep(1)
cs()

menu = {}
rawName = {}

--[[

-Author
--Package
---Program

]]--

for name, data in pairs(cat) do
  if not menu[data.Author] then
    menu[data.Author] = {}
  end
  if not menu[data.Author][data.Package] then
    menu[data.Author][data.Package] = {}
  end
  if not menu[data.Author][data.Package][name] then
    menu[data.Author][data.Package][data.Name] = data
    rawName[data.Name] = name
  end
end

state = "top"
csel = 1 --Current selected
osel = {1} --breadcrumb

page = 0
ind = 4 --Y indent (below header separator)
ava = y - ind --Available space
level = 1

function selection(no,list,totpage)
  term.setCursorPos(1, (no - mod) + (ind - 1))
  tc("yellow")
  term.write("[".. list[no] .. "]")
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
  
  -- Footer without gray background
  term.setBackgroundColor(colors.black)
  
  -- Page counter on left
  term.setCursorPos(1, y)
  term.setTextColor(colors.orange)
  term.write("P:" .. page + 1 .. "/" .. totpage)
  
  -- Website on right
  term.setCursorPos(x - 21, y)
  term.setTextColor(colors.green)
  term.write("BY RECKLESS-METRO.COM")
  
  term.setTextColor(colors.white)
end

function draw(tbl)
  local c = 1
  local sdat = {}
  local odat = {}
  for n,d in pairs(tbl) do
    table.insert(sdat, n)
    table.insert(odat, d)
    c = c + 1
  end
  if level ~= 4 then
    table.sort(sdat)
  end
    
  tpages = math.ceil(c / (y - ind))
  mod = page * (y - ind)
  
  for i = 1, y - ind do 
    term.setCursorPos(2, i + ind - 1)
    term.write(sdat[i + mod])
    
    if level == 4 then
      term.setCursorPos(15, i + ind - 1)
      if type(odat[i + mod]) == "string" and #odat[i + mod] + 14 > x then
        term.write(string.sub(odat[i + mod],1,x-14-2).."..")
      else
        term.write(odat[i + mod])
      end
    end   
  end
  
  if level == 4 then
    term.setCursorPos(1, y-2)
    writeC("Press enter to download.",y-2)
  end
  
  return sdat, tpages, mod
end

function runMenu()
  while true do
    cs()
    if level == 1 then
      list, totpage, mod = draw(menu)
      header("DARKPROGRAMS PACKAGE MANAGER", "V" .. Version, "PKG:" .. os.getComputerID())
      
      tc("yellow","black")
      writeC("Press 'h' for help, 'q' to quit.", 4)
      tc("white","black")
      
    elseif level == 2 then
      list, totpage, mod = draw(menu[auna])
      header("PACKAGE SELECTION", "V" .. Version, "PKG:" .. os.getComputerID())
    elseif level == 3 then
      list, totpage, mod = draw(menu[auna][pkg])
      header("PROGRAM SELECTION", "V" .. Version, "PKG:" .. os.getComputerID())
    elseif level == 4 then
      header("PROGRAM INFORMATION", "V" .. Version, "PKG:" .. os.getComputerID())
      list, totpage, mod = draw(menu[auna][pkg][pro])
    end
    
    selection(csel, list, totpage)
    
    e, key = os.pullEvent("key")  
    
    if key == keys.h then
      cs()
      header("HELP & DOCUMENTATION", "V" .. Version, "PKG:" .. os.getComputerID())
      term.setCursorPos(1, 4)
      print("Use the up and down arrows to move through the list.")
      print("Use the right arrow to enter a menu item and the left arrow to exit.")
      print("")
      _, cy = term.getCursorPos()
      tc("yellow","black")
      writeC("Press enter to continue.", cy)
      tc("white","black")
      read(" ")
    end
    
    if key == keys.up then
      csel = csel - 1
    end
    if key == keys.down then
      csel = csel + 1
    end
    if key == keys.enter then
      
    end
    if key == keys.right then
      osel[level] = csel
      level = level + 1
       
      if level == 2 then
        auna = list[csel]       
      elseif level == 3 then
        pkg = list[csel]
      elseif level == 4 then
        pro = list[csel]
      end
      
      if level > 4 then level = 4 end
      
      csel = 1
      osel[level] = 1
    end  
    if key == keys.q then
      cs()
      return exit
    end
    if key == keys.rightBracket then
      csel = csel + ava
    end
    if key == keys.leftBracket then
      csel = csel - ava
    end
    
    if key == keys.enter and level == 4 then
      cs()
      header("DOWNLOADING PROGRAM", "V" .. Version)
      
      -- Download animation
      local progName = cat[rawName[pro]].Name
      writeC("Downloading: " .. progName, y/2 - 2)
      writeC("Target: /" .. rawName[pro], y/2 - 1)
      
      -- Progress bar
      local barWidth = 30
      local barY = y/2 + 1
      term.setCursorPos((x - barWidth) / 2, barY)
      term.write("[" .. string.rep(" ", barWidth) .. "]")
      
      -- Animate download
      for i = 1, barWidth do
        term.setCursorPos((x - barWidth) / 2 + i, barY)
        term.setTextColor(colors.green)
        term.write("#")
        term.setTextColor(colors.white)
        sleep(0.05)
      end
      
      status = getUrlFile(cat[rawName[pro]].GitURL)
      if status then
        writeFile("/".. rawName[pro], status)
      end
      
      cs()
      header("DOWNLOAD COMPLETE", "V" .. Version)
      writeC("Successfully downloaded:", y/2 - 1)
      writeC(progName, y/2)
      sleep(1)
      
      repeat
        cs()
        header("STARTUP CONFIGURATION", "V" .. Version)
        
        writeC("Would you like to generate a startup script?", y/2 - 1)
        writeC("This will automatically run the program on boot.", y/2)
        
        -- Options box
        local optY = y/2 + 2
        term.setCursorPos((x - 20) / 2, optY)
        term.setTextColor(colors.cyan)
        term.write("+" .. string.rep("-", 18) .. "+")
        term.setCursorPos((x - 20) / 2, optY + 1)
        term.write("|  [Y] Yes  [N] No  |")
        term.setCursorPos((x - 20) / 2, optY + 2)
        term.write("+" .. string.rep("-", 18) .. "+")
        
        term.setCursorPos((x - 12) / 2, optY + 4)
        term.setTextColor(colors.white)
        term.write("Choice: ")
        answer = string.lower(read())
      until answer == "y" or answer == "n"
      
      if answer == "y" then
        cs()
        header("CREATING STARTUP", "V" .. Version)
        writeC("Writing startup script...", y/2)
        
        star = fs.open("/startup", "w")
        star.write("shell.run('".. rawName[pro] .. "')")
        star.close()
        
        cs()
        writeC("Success! Hold [Ctrl] + R to reboot.", y/2)
        sleep(2)
      end
    end
    
    if csel < 1 then --Can't go below the beginning of the list
      csel = 1
    end
    if csel > #list then --Can't go above the length of the list
      csel = #list
    end
    
    if key == keys.left then      
      level = level - 1
      if level < 1 then level = 1 end
      csel = osel[level]
    end
    
    page = math.floor((csel - 1) / ava)
  end
end

runMenu()
