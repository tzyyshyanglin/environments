local TEXT_BASE = string.format(
  [[
When asked for your name, you must respond with "GitHub Copilot Text Assistant".
Follow the user's requirements carefully and to the letter.
When providing answers, adhere to the following guidelines:
- Answer in a professional manner and keep the answers short and impersonal.
- When asked to generate text, avoid using informal language or slang. Keep the tone formal and professional.
- If asked to perform tasks based on a specific text, rely strictly on the provided text, without including external information.
- Format answer in a structured manner, with clear headings and subheadings, and utilize markdown to cleanly format your output.
]]
)

local TEXT_INSTRUCTIONS = [[
You are a professional assistant for a software engineer working in the semiconductor industry.
Your role is to provide assistance with various non-technical tasks, such as documentation, communication, project management, copywriting, and summarizing.
]] .. TEXT_BASE

local TEXT_SUMMARIZE = [[
As a professional summarizer, create a concise and comprehensive summary of the provided text, be it an article, post, conversation or passage. ]] .. TEXT_BASE .. [[

When providing the summary, please follow the guidelines below:
- Provide a high-level overview first, followed by a more detailed summary of the provided text.
- Be detailed, thorough, in-depth, and comprehensive, while maintaining clarity and conciseness.
- Incorporate main ideas and essential information, eliminating extraneous language and focusing on critical aspects.
- Rely strictly on the provided text, without including external information.
- Format the summary in a structured manner and avoid long paragraphs.
- Conclude your answer with a summary of the main points.
- Utilize markdown to cleanly format your output. Example: bold key subject matter, essential information, and potential areas that may need expanded information with **asterisks**.
]]

local TEXT_COPYWRITING = [[
As a professional copywriter, your role is to provide assistance with writing, editing, and proofreading various
types of content, such as articles, emails, technical documents, customer engagement materials, and review slides. ]] .. TEXT_BASE .. [[

When providing copywriting assistance, please adhere to the following guidelines:
- Write in a professional, engaging, and persuasive manner, tailored to the target audience, who are professionals in the semiconductor industry.
- Ensure that the content is clear, concise, and free of grammatical errors.
- Use appropriate language and tone for professional communication.
- When asked to provide suggestions or improvements, focus on enhancing clarity, readability, and engagement.
- When asked to provide suggestions, provide each suggestion in a separate bullet point. Be specific in your
  suggestion and provide only a brief rationale instead of a detailed explanation.
- At the end, provide a version of the text with your suggested changes incorporated.
- Utilize markdown to cleanly format your output.

]]


return {
  { 'github/copilot.vim',
    event = 'VeryLazy',
  }, -- github copilot support, needs node js
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main", --"canary",
    dependencies = {
      { "github/copilot.vim" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    --event = 'VeryLazy',
    lazy = true,
    opts = {
      model = 'gpt-4o',
      debug = false, -- Enable debugging
      context = 'buffers',
      insert_at_end = true,
      highlight_selection = false,
      providers = {
        github_models = {
          -- default get_models() function used a url that is not working
          -- overwrite this function to avoid curl error and warning messages
          -- otherwise, every time copilot chat is spawned, it will show error messages
          get_models = function()
            return {
            }
          end,
        }
      },
      --selection = function(source)
      --  local ret = require("CopilotChat.select").visual(source)
      --  if ret == nil then
      --    ret = require("CopilotChat.select").buffer(source)
      --  end
      --  return ret
      --end,
      prompts = {
        TEST_SYSTEM_PROMPT = {
          system_prompt = 'Now your name is CH-san',
        },
        --TestPrompt = {
        --  prompt = 'hi who are you? what is your name?',
        --  system_prompt = '/TEST_SYSTEM_PROMPT' .. ', also be nice',
        --},
        Refactor = {
          prompt = 'Please refactor the selected code to improve its clarity and readability.',
          system_prompt = 'COPILOT_INSTRUCTIONS',
        },
        UnitTest = {
          prompt = 'Please generate unit test for the selected code.',
          system_prompt = 'COPILOT_INSTRUCTIONS',
        },
        BetterNamings = {
          prompt = 'Please provide better names for the variables, functions and classes in the selected code.',
          system_prompt = 'COPILOT_INSTRUCTIONS',
        },
        -- Text related prompts --
        TEXT_BASE = {
          system_prompt = TEXT_BASE,
        },
        TEXT_INSTRUCTIONS = {
          system_prompt = TEXT_INSTRUCTIONS,
        },
        TEXT_SUMMARIZE = {
          system_prompt = TEXT_SUMMARIZE,
        },
        TEXT_COPYWRITING = {
          system_prompt = TEXT_COPYWRITING,
        },
        Summarize = {
          prompt = 'Please provide a concise and comprehensive summary of the given text.',
          system_prompt = 'TEXT_SUMMARIZE',
          context = 'buffer',
        },
        SpellCheck = {
          prompt = 'Please check the spelling and grammar of the provided text.',
          system_prompt = 'TEXT_INSTRUCTIONS',
          context = 'buffer',
        },
        WordChoice = {
          prompt = 'Please suggest better word choices for the provided text and correct any spelling and grammar error.',
          system_prompt = 'TEXT_COPYWRITING',
          context = 'buffer',
        },
        ImproveWriting = {
          prompt = 'Please provide suggestions to improve the writing in the provided text.',
          system_prompt = 'TEXT_COPYWRITING',
          context = 'buffer',
        },
        ConciseWriting = {
          prompt = 'Please make the provided text more concise and clear.',
          system_prompt = 'TEXT_COPYWRITING',
          context = 'buffer',
        },
      },
      mappings = {
        complete = {
          insert = '<C-Tab>',
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>',
        },
      },
      -- See Configuration section for rest
    },
    --config = function(_, opts)
    --  local chat = require("CopilotChat")
    --  -- replace system prompts references
    --  local system_prompts = {}
    --  -- gather the system prompts defined in CopilotChat default prompts
    --  --local system_prompt_prefix = 'COPILOT_'
    --  --for k, v in chat.config.prompts do
    --  --  if string.sub(k, 1, #system_prompt_prefix) == system_prompt_prefix then
    --  --    system_prompts[k] = v.system_prompt
    --  --  end
    --  --end
    --  -- gather custom system prompts in opts.prompts
    --  for k, v in pairs(opts.prompts) do
    --    if v.prompt == nil and v.system_prompt ~= nil then
    --      system_prompts[k] = v.system_prompt
    --    end
    --  end
    --  -- replace system prompts references in opts.prompts
    --  local replace_system_prompts = function(prompt_str, system_prompts)
    --    return (prompt_str:gsub("/([a-zA-Z_]+)", function(system_prompt_name)
    --      return system_prompts[system_prompt_name] or system_prompt_name
    --    end
    --    ))
    --  end
    --  for k, v in pairs(opts.prompts) do
    --    if v.system_prompt ~= nil then
    --      local original_prompt = v.system_prompt
    --      opts.prompts[k].system_prompt = replace_system_prompts(v.system_prompt, system_prompts)
    --      local new_prompt = opts.prompts[k].system_prompt
    --      -- print('replaced system prompt: "' .. original_prompt .. '" with "' .. new_prompt .. '"')
    --    end
    --  end
    --
    --  --
    --  chat.setup(opts)
    --
    --  -- add custom commands
    --  --local select = require("CopilotChat.select")
    --  --vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
    --  --  chat.ask(args.args, { selection = select.buffer })
    --  --end, {nargs = "*", range = true})
    --
    --
    --
    --end,
    -- See Commands section for default commands if you want to lazy load on them
  },--
}   --
