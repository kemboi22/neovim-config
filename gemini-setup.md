# Google Gemini API Setup

## Step 1: Get Your API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the generated API key

## Step 2: Set Up Environment Variable

### Option 1: Add to Shell Configuration (Permanent)

```bash
# For Bash users
echo 'export GEMINI_API_KEY="your_api_key_here"' >> ~/.bashrc
source ~/.bashrc

# For Zsh users
echo 'export GEMINI_API_KEY="your_api_key_here"' >> ~/.zshrc
source ~/.zshrc
```

**Replace `your_api_key_here` with your actual API key!**

### Option 2: Set for Current Session (Temporary)

```bash
export GEMINI_API_KEY="your_api_key_here"
```

### Option 3: Create a .env file (Project-specific)

```bash
# Create a .env file in your project root
echo 'GEMINI_API_KEY="your_api_key_here"' > .env

# Load it when needed
source .env
```

## Step 3: Verify Setup

```bash
# Check if the API key is set
echo $GEMINI_API_KEY

# Should output your API key (not empty)
```

## Step 4: Update AI Assistant Configuration (Optional)

The configuration is already set to use Ollama by default. To switch to Gemini:

1. Edit `lua/plugins/ai-assistant.lua`
2. Change the adapter from `"ollama"` to `"gemini"` in the strategies section:

```lua
strategies = {
  chat = {
    adapter = "gemini",  -- Changed from "ollama"
  },
  inline = {
    adapter = "gemini",  -- Changed from "ollama"
  },
  agent = {
    adapter = "gemini",  -- Changed from "ollama"
  },
},
```

For Avante.nvim, change the provider:

```lua
opts = {
  provider = "gemini",  -- Changed from "ollama"
  -- ... rest of config
}
```

## Step 5: Restart Neovim

After setting up the API key and updating the configuration:

1. Close Neovim
2. Restart your terminal (or run `source ~/.bashrc`/`source ~/.zshrc`)
3. Start Neovim again

## Switching Between Providers

You can easily switch between Ollama (local) and Gemini (cloud) by:

1. **In CodeCompanion**: Use `:CodeCompanionActions` and select different adapters
2. **In Configuration**: Change the `adapter` values in the config file
3. **Environment**: Set/unset the `GEMINI_API_KEY` variable

## Security Note

⚠️ **Important**: Never commit your API key to version control!

- Add `.env` to your `.gitignore` file
- Use environment variables instead of hardcoding keys
- Consider using a secret management tool for production

## Troubleshooting

### API Key Not Working

```bash
# Check if API key is set
echo $GEMINI_API_KEY

# Check if it's the correct length (should be fairly long)
echo ${#GEMINI_API_KEY}
```

### Rate Limits

- Gemini has usage quotas and rate limits
- Check your usage at [Google AI Studio](https://makersuite.google.com/)
- Consider using Ollama for unlimited local usage

### Network Issues

- Ensure you have internet connectivity
- Check if your firewall/proxy allows HTTPS requests to Google APIs

## Model Comparison

| Model          | Speed     | Capability | Cost    | Internet Required |
| -------------- | --------- | ---------- | ------- | ----------------- |
| Ollama (Local) | Fast      | Good       | Free    | No                |
| Gemini Pro     | Medium    | Excellent  | Paid    | Yes               |
| Gemini Flash   | Very Fast | Good       | Cheaper | Yes               |

Choose based on your needs:

- **Ollama**: For privacy, offline work, unlimited usage
- **Gemini**: For best quality, advanced reasoning, latest features
