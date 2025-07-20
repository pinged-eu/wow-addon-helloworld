local options = {
    name = "MyAddon",
    handler = HelloWorld,
    type = 'group',
    args = {
        msg = {
            type = 'input',
            name = 'My Message',
            desc = 'The message for my addon',
            set = 'SetMyMessage',
            get = 'GetMyMessage',
        },
    },
}
LibStub("AceConfig-3.0"):RegisterOptionsTable("HelloWorld", options, { "myslash", "myslashtwo" })
