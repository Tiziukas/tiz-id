Config = {}

Config.PedLocation = {
    ['Dealer'] = {                                           -- 
        ped = {                                                 -- Determines ped variables.
            coords = vec4(-1428.8152, -249.5527, 46.3791, 48.4938),-- Determines the coords of the ped (Needs to be a vector4).
            model = 'a_m_m_afriamer_01',                          -- Determines the ped model. (Optional)
            scenario = 'WORLD_HUMAN_DRUG_DEALER_HARD',                 -- Determines the ped scenario. (Optional)
        },
    },
}
Config.InteractionMethod = "target" -- No Support For TextUI yet.
Config.Price = 2500
Config.PaymentType = "black_money" -- black_money or money
Config.Command = "fakeid"

Config.Language = {
    buy = 'Buy a fake ID!',
    buydescription = 'Ask the plug for an ID!',
    idmenu = 'Buy an ID',
    name = 'First Name',
    namedesc = 'Add your name here',
    lname = 'Last Name',
    lnamedesc = 'Add your last name here',
    dobas = 'Date of Birth',
    gender = 'Gender',
    male = 'Male',
    female = 'Female',
    category = 'Category',
    height = 'Height',
    notifytitle = 'Plug',
    notifysucces = 'You received a Fake ID!',
    notifyalready = 'You already have a license!',
    notifymoney = 'You do not have enough money!',
    pedname = 'Plug',
    menudesc = 'No one nearby!',
    titlemenu = 'Fake ID Menu',
    menutitle = 'Fake ID Dealer',
    categorya = 'A',
    categoryb = 'B',
    idtitle = 'Options:',
    categoryc = 'C',
    checktitle = 'Check your Fake ID',
    checkdesc = 'Displays the ID to you',
    showtitle = 'Show your Fake ID',
    showkdesc = 'Shows your ID to the closest person',
    eyepedname = 'Plug'

}