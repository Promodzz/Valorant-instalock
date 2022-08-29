from pystray import Menu, Icon, MenuItem as Item
from PIL import Image, ImageGrab
from pynput import mouse
import pyautogui, json, threading, time, math

class ProgamError(Exception):
    pass

class Program:
    def __init__(self, name: str, lang: str) -> None:
        """Library to instalock an agent in Valorant"""

        self.name = name
        self.lang = lang.lower()
        self.activity = True
        self.thread_activity = True
        self.coords = None
        self.agentName = None

        self.languages()
        self.getAgents()

        try: self.icons = (Image.open("data/icon_enable.ico"), Image.open("data/icon_disable.ico"))
        except: raise ProgamError(self.data["IconError"])


    def close(self) -> None:
        """Closes the thread"""

        self.thread_activity = False
        self.icon.stop()


    def languages(self) -> None:
        """Set the language 'es' or 'en'"""

        if self.lang not in ['es', 'en']:
            raise ProgamError(self.data["LangError"])

        with open(f'data/{self.lang}.json', 'r', encoding="utf-8") as file:
            j_file = json.load(file)
            self.data = j_file


    def changeActivity(self) -> str:
        """Start o stop the instalocker"""

        if self.activity:
            self.activity = False
            final = "stoped"

        else:
            self.activity = True
            final = "started"

        self.changeIcon()

        return final


    def getAgents(self) -> None:
        """Return all the agents saved"""

        with open(f'data/agents.json', 'r', encoding="utf-8") as file:
            j_file = json.load(file)

            self.agents = [x for x in j_file.keys() if x != "ALL"]
            self.all_agents = j_file["ALL"]
            self.agents_data = j_file

        try: self.agentName = self.agents_data["DEFAULT"]
        except: pass


    def changeIcon(self) -> None:
        """Switches the icon between on and off"""

        if self.activity: self.icon.icon = self.icons[0]
        else: self.icon_image = self.icon.icon = self.icons[1]


    def changeAgent(self, agent: str) -> None:
        """Switches to the selected agent"""
        
        self.agentName = agent
        self.icon.notify(f'{self.data["Notification"]}: {agent}')

        with open(f'data/agents.json', 'r', encoding="utf-8") as file:
            j_file = json.load(file)
            j_file["DEFAULT"] = agent

        with open(f'data/agents.json', 'w', encoding="utf-8") as file:
            file.write(json.dumps(j_file, indent=4))

    def setAgent(self, agent: str) -> None:
        """Locate and save the selected agent (pixels and colors)"""

        def on_click(x, y, button, pressed):
            # https://stackoverflow.com/questions/39235454/how-to-know-if-the-left-mouse-click-is-pressed
            if button == mouse.Button.left:
                # print('{} at {}'.format('Pressed Left Click' if pressed else 'Released Left Click', (x, y)))
                self.coords = [x, y]
                return False
            
            # elif button == mouse.Button.right:
            #     print('{} at {}'.format('Pressed Right Click' if pressed else 'Released Right Click', (x, y)))
            # else: return False

        self.icon.notify(message=self.data["InstructionsText"] + agent, title=self.data["Instructions"])

        listener = mouse.Listener(on_click=on_click)
        listener.start()
        
        while self.coords == None:
            time.sleep(0.1)

        if agent == "CONFIRMATION_BUTTON":
            radio = 10
            original = [*self.coords]

            radio_points = [x for x in range(-radio, radio + 1)]
            coord_list = []

            for x in radio_points:
                temp_coords = [*self.coords]

                pixel_color = ImageGrab.grab().load()[temp_coords[0], temp_coords[1]]
                temp_coords.append(pixel_color)
                coord_list.append(temp_coords)

                self.coords[0] = original[0] + x
        else:
            pixel_color = ImageGrab.grab().load()[self.coords[0], self.coords[1]]
            self.coords.append(pixel_color)

        with open(f'data/agents.json', 'r', encoding="utf-8") as file:
            j_file = json.load(file)
            
            if agent != "CONFIRMATION_BUTTON":
                j_file["DEFAULT"] = agent
                self.agentName = agent

            if agent == "CONFIRMATION_BUTTON": j_file[agent] = [self.coords, coord_list]
            else: j_file[agent] = self.coords

        with open(f'data/agents.json', 'w', encoding="utf-8") as file:
            file.write(json.dumps(j_file, indent=4))

        pressed = pyautogui.alert(text=agent + self.data["AgentAddedText"], title=self.data["AgentAdded"], button='OK')
        while pressed != 'OK': time.sleep(0.2)
        self.coords = None
        self.getAgents()


    def clear(self):
        with open(f'data/agents.json', 'r', encoding="utf-8") as file:
            j_file = json.load(file)
            temp = [x for x in j_file]
            
            for x in temp:
                if x == "ALL": continue
                del j_file[x]

        with open(f'data/agents.json', 'w', encoding="utf-8") as file:
            file.write(json.dumps(j_file, indent=4))

        self.agentName = None
        self.agents = []
        self.agents_data = j_file


    def createItem(self, agent: str, saved: bool =False) -> object:
        """Creates a menu item"""

        if saved:
            item = Item(
                agent, 
                lambda: self.changeAgent(agent), 
                checked=lambda x: self.agentName == agent, 
                visible=lambda x: (agent in self.agents) and (agent != "CONFIRMATION_BUTTON")
            )
            return item
        else:
            item = Item(agent, lambda: self.setAgent(agent), checked=lambda x: agent in self.agents, radio=True)
            return item


    def relative_error(self, list1: list, list2: list, tolerancy: int =0) -> bool:
        final = False

        if len(list1) == len(list2):
            for x in range(len(list1)):
                # print(list1[x], list2[x])
                if math.isclose(list1[x], list2[x], abs_tol=tolerancy):
                    final = True
                else:
                    final = False
                    break
        else: print("[·] Lists dont have the same number of items")
        
        return final


    def p_thread(self) -> None:
        """Starts the thread that is in charge of choosing the agent"""

        first = True
        
        while self.thread_activity:
            if not self.agentName and self.agents: self.agentName = self.agents[0]
            if not self.agentName:
                time.sleep(1)
                continue

            found = 0

            if self.activity and "CONFIRMATION_BUTTON" in self.agents and len(self.agents) > 1:
                # Check that the user is on the agent selection screen

                crd = self.agents_data["CONFIRMATION_BUTTON"][1]
                for x in crd:
                    color = ImageGrab.grab().load()[x[0], x[1]]
                    # print(color, x[2], found, len(crd))

                    if self.relative_error(list(color), x[2], 2): found += 1
                    else: break

                if found == len(crd):
                    coords = self.agents_data[self.agentName][0], self.agents_data[self.agentName][1]
                    agent_color = self.agents_data[self.agentName][2]

                    print(f'Searching: {self.agentName} - coords: {coords} color: {agent_color}')
                    
                    # Pick agent
                    # print(list(ImageGrab.grab().load()[coords[0], coords[1]]), agent_color)
                    if self.relative_error(list(ImageGrab.grab().load()[coords[0], coords[1]]), agent_color, 30):
                        print('Agent found!')
                        pyautogui.click(*coords)

                        # Click confirmation button
                        conf_btn = self.agents_data["CONFIRMATION_BUTTON"][0]
                        pyautogui.moveTo(conf_btn[0], conf_btn[1], duration=0.1)
                        pyautogui.moveTo(conf_btn[0], conf_btn[1] - 100, duration=0.2)
                        pyautogui.click(*conf_btn, clicks=2, duration=0.2)
                        print('Confirmation Button clicked')

            elif self.activity and first:
                time.sleep(2)
                self.icon.notify(message=self.data["DataLack"], title=self.data["Warning"])
                first = False
            else: pass

            time.sleep(0.5)

    def start(self) -> None:
        """Inicia el Instalocker"""

        self.thread = threading.Thread(target=self.p_thread).start()

        menu = Menu(
            Item(
                lambda x: f'{self.data["Status"]}: {self.data["Enable"] if self.activity else self.data["Disable"]}', 
                lambda: self.changeActivity(), checked=lambda x: self.activity, 
                default=True
            ),
            Item(self.data["Agents"], Menu(*[self.createItem(agent, True) for agent in self.all_agents])),
            Item(self.data["Add"], Menu(*[self.createItem(agent) for agent in self.all_agents])),
            Item(self.data["Reset"], lambda: self.clear()),
            Item(self.data["Exit"], lambda: self.close())
        )

        try:
            self.icon = Icon(self.name, self.icons[0], self.name, menu)
            self.icon.run()
        except: raise ProgamError(self.data["ProgamError"])