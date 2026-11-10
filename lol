local TextChatService = game:GetService("TextChatService")

while task.wait(5) do
    local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if channel then
        channel:SendAsync("gentleman on top")
    end
end
