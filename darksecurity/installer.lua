-- Get terminal dimensions
x, y = term.getSize()
co = "blue"

-- Server-style header function
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
  term.write(string.rep(" ", x))
end

-- Server-style footer function
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
  term.write("Setup Wizard")
  term.setCursorPos(x-8, y)
  term.setTextColor(colors.orange)
  term.write("ID:" .. os.getComputerID())
end

-- Menu option function like server
function printR(text, option)
  term.setTextColor(colors.yellow)
  print(text)
  term.setTextColor(colors.white)
end

-- Reset colors function
function resetColors()
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
end

-- CD Autorun splash
function cdSplash()
  term.clear()
  header("DARKPROGRAMS INSTALLATION CD", "v2.0", "AUTORUN")
  footer()
  resetColors()
  
  -- CD Icon
  term.setCursorPos(math.floor(x/2) - 5, 6)
  term.setTextColor(colors.cyan)
  term.write("   ___   ")
  term.setCursorPos(math.floor(x/2) - 5, 7)
  term.write("  /   \\  ")
  term.setCursorPos(math.floor(x/2) - 5, 8)
  term.write(" |  O  | ")
  term.setCursorPos(math.floor(x/2) - 5, 9)
  term.write("  \\___/  ")
  
  term.setCursorPos(1, 12)
  term.setTextColor(colors.white)
  term.write("=== DARKPROGRAMS SECURITY SUITE ===")
  term.setCursorPos(1, 14)
  term.setTextColor(colors.gray)
  term.write("Professional Security Solutions for ComputerCraft")
  term.setCursorPos(1, 15)
  term.write("Copyright (c) DarkPrograms. All rights reserved.")
  
  term.setCursorPos(1, 17)
  term.setTextColor(colors.yellow)
  term.write("Press any key to continue...")
  os.pullEvent("key")
end

-- CD Autorun sequence
cdSplash()

-- Main installer menu
function mainMenu()
  while true do
    term.clear()
    header("DARKPROGRAMS SETUP WIZARD", "v2.0", "INSTALL")
    footer()
    resetColors()
    
    print("")
    term.setTextColor(colors.white)
    print("=== INSTALLATION OPTIONS ===")
    print("")
    printR("  [1] # INSTALL SECURITY SERVER", 1)
    printR("  [2] @ INSTALL SECURITY CLIENT", 2)
    printR("  [3] ! SYSTEM REQUIREMENTS", 3)
    print("")
    term.setTextColor(colors.white)
    print("=== ADVANCED OPTIONS ===")
    print("")
    printR("  [4] % CUSTOM INSTALLATION", 4)
    printR("  [5] ? HELP & DOCUMENTATION", 5)
    printR("  [6] X EXIT INSTALLER", 6)
    
    -- Status box
    term.setCursorPos(1, y-4)
    term.setTextColor(colors.cyan)
    term.write("+" .. string.rep("-", 28) .. "+")
    term.setCursorPos(1, y-3)
    term.write("| SYSTEM STATUS: READY        |")
    term.setCursorPos(1, y-2)
    term.write("+" .. string.rep("-", 28) .. "+")
    
    term.setCursorPos(1, y-6)
    term.setTextColor(colors.white)
    write("Select option [1-6]: ")
    local choice = read()
    
    if choice == "1" then
      installProgram("server")
      break
    elseif choice == "2" then
      installProgram("client")
      break
    elseif choice == "3" then
      showRequirements()
    elseif choice == "4" then
      customInstall()
      break
    elseif choice == "5" then
      showHelp()
    elseif choice == "6" then
      term.clear()
      print("Installation cancelled.")
      return
    end
  end
end

function showRequirements()
  term.clear()
  header("SYSTEM REQUIREMENTS", "v2.0", "INFO")
  footer()
  resetColors()
  
  print("")
  term.setTextColor(colors.white)
  print("=== MINIMUM REQUIREMENTS ===")
  print("")
  term.setTextColor(colors.yellow)
  print("> ComputerCraft Computer")
  print("> HTTP API enabled")
  print("> Wireless/Wired Modem (for networking)")
  print("> Redstone I/O (for door control)")
  print("")
  
  term.setTextColor(colors.cyan)
  print("=== CHECKING SYSTEM ===")
  print("")
  
  -- HTTP Check
  term.setTextColor(colors.yellow)
  write("> HTTP API: ")
  if http then
    term.setTextColor(colors.green)
    print("ENABLED")
  else
    term.setTextColor(colors.red)
    print("DISABLED - Please enable in config")
  end
  
  term.setTextColor(colors.white)
  print("")
  print("Press any key to continue...")
  os.pullEvent("key")
end

function showHelp()
  term.clear()
  header("HELP & DOCUMENTATION", "v2.0", "HELP")
  footer()
  resetColors()
  
  print("")
  term.setTextColor(colors.white)
  print("=== DARKPROGRAMS SECURITY SUITE ===")
  print("")
  term.setTextColor(colors.gray)
  print("Professional access control system for")
  print("ComputerCraft environments.")
  print("")
  term.setTextColor(colors.yellow)
  print("Features:")
  print("- Keycard & Password Authentication")
  print("- Multi-level Security Clearances")
  print("- Encrypted Communications")
  print("- Centralized User Management")
  print("- Automatic Updates")
  print("")
  term.setTextColor(colors.white)
  print("Press any key to continue...")
  os.pullEvent("key")
end

function customInstall()
  -- Custom installation logic here
  installProgram("custom")
end

function installProgram(programType)
  if not http then
    term.clear()
    header("INSTALLATION ERROR", "v2.0", "ERROR")
    footer()
    resetColors()
    print("")
    term.setTextColor(colors.red)
    print("[ERROR] HTTP API is not enabled")
    print("Please enable HTTP in ComputerCraft config")
    print("")
    term.setTextColor(colors.white)
    print("Press any key to exit...")
    os.pullEvent("key")
    return
  end
  
  programs = {}
  if programType == "server" then
    table.insert(programs, "server")
  elseif programType == "client" then
    table.insert(programs, "client")
  else
    -- Custom install - ask user
    term.clear()
    header("CUSTOM INSTALLATION", "v2.0", "SETUP")
    footer()
    resetColors()
    
    print("")
    term.setTextColor(colors.white)
    print("=== PROGRAM SELECTION ===")
    print("")
    repeat
      term.setTextColor(colors.cyan)
      write("Install [Server/Client]: ")
      local answer = read()
      if answer:lower() == "server" then
        table.insert(programs, "server")
        break
      elseif answer:lower() == "client" then
        table.insert(programs, "client")
        break
      end
    until false
  end

  -- Installation path
  print("")
  term.setTextColor(colors.cyan)
  print("Installation Directory:")
  term.setTextColor(colors.gray)
  print("Default: / (Press Enter for default)")
  term.setTextColor(colors.white)
  write("Path: ")
  local pathAnswer = read()
  
  if pathAnswer == "" then
    pathAnswer = "/"
  end

  -- Download and install
  term.clear()
  header("INSTALLING PROGRAMS", "v2.0", "PROGRESS")
  footer()
  resetColors()
  
  print("")
  term.setTextColor(colors.white)
  print("=== INSTALLATION PROGRESS ===")
  print("")
  
  term.setTextColor(colors.yellow)
  print("> Connecting to download server...")
  
  local status, getGit = pcall(http.get, "https://raw.githubusercontent.com/rservices/darkprograms/darkprograms/programVersions")
  if not status then
    term.setTextColor(colors.red)
    print("[ERROR] Failed to connect to server")
    print("Error: ".. getGit)
    print("")
    term.setTextColor(colors.white)
    print("Press any key to exit...")
    os.pullEvent("key")
    return
  end
  
  local getGit = getGit.readAll()
  local NVersion = textutils.unserialize(getGit)
  
  term.setTextColor(colors.green)
  print("+ Connected successfully")
  
  for i = 1, #programs do
    term.setTextColor(colors.yellow)
    print("> Installing: "..programs[i])
    
    getGit = http.get(NVersion[programs[i]].GitURL)
    getGit = getGit.readAll()
    local file = fs.open(pathAnswer..programs[i], "w")
    file.write(getGit)
    file.close()
    
    term.setTextColor(colors.green)
    print("+ Installed: "..programs[i])
    sleep(0.5)
  end
  
  print("")
  term.setTextColor(colors.cyan)
  print("=== CONFIGURATION ===")
  print("")
  term.setTextColor(colors.yellow)
  print("Create startup file for auto-launch?")
  term.setTextColor(colors.white)
  write("[Y/N]: ")
  local startupAnswer = read()
  
  if startupAnswer:lower() == "y" then
    local file = fs.open("startup", "w")
    file.write("shell.run(\"".. programs[1] .."\")")
    file.close()
    term.setTextColor(colors.green)
    print("+ Startup file created")
  else
    term.setTextColor(colors.gray)
    print("- Startup file skipped")
  end
  
  -- Installation complete
  term.clear()
  header("INSTALLATION COMPLETE", "v2.0", "SUCCESS")
  footer()
  resetColors()
  
  print("")
  term.setTextColor(colors.green)
  print("[SUCCESS] Installation completed successfully!")
  print("")
  term.setTextColor(colors.white)
  print("DarkPrograms Security Suite has been installed.")
  term.setTextColor(colors.gray)
  print("Thank you for choosing our security solutions.")
  
  print("")
  term.setTextColor(colors.yellow)
  print("=== NEXT STEPS ===")
  term.setTextColor(colors.white)
  print("1. Configure your security settings")
  print("2. Set up user accounts and access cards")
  print("3. Test the system functionality")
  
  print("")
  term.setTextColor(colors.orange)
  print("> Restarting system in 5 seconds...")
  sleep(5)
  os.reboot()
end

-- Start the installer
mainMenu()
