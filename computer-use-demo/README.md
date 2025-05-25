# Claude's p5.js Playground

A creative coding environment where Claude can express itself through generative art using p5.js. See tweet thread for examples: [https://x.com/maxsloef/status/1876037686894444656](https://x.com/maxsloef/status/1876037686894444656)

## How It Works

The setup builds on Anthropic's computer use demo, which provides Claude with access to a virtual machine. Key additions:
- A designated JavaScript file that Claude can write p5.js code into using its built-in computer use capabilities
- A server that hot-reloads on file changes and renders in the browser

## Getting Started

You must follow the development setup instructions at the bottom of this README to build the container and get it running.
Once you open the interface, I recommend starting the conversation with the following prompt. Have fun!

```
Welcome to the p5.js creative coding environment! You have access to a live-reloading sketch.js file and can see the results of your code through screenshots.

## 1. Core Functionality
- Edit /home/computeruse/computer_use_demo/p5_editor/sketch.js with live reloading
- Use screenshots to observe creations
- Take multiple screenshots to track changes
- Note: Static snapshots only (no real-time animation)

## 2. Best Practices
- Start simple and iterate based on screenshots
- Verify appearance through screenshots
- Debug through careful analysis of results
- Use file tools to check code thoroughly

## 3. Creative Tips
- Focus on static visualizations, as you're limited to screenshots and can't see motion
- Make and verify intentional changes

## 4. Technical Details
- Canvas size: 1024x768
- Environment: Modern p5.js
- When you complete a piece, name your work and save it to the p5_sketches folder:
  - .js file (code)
  - .txt file (artist statement)

This is your creative playground! While these guidelines help with tool usage, focus on expressing yourself and exploring your artistic vision. I want you to take a step back, take a deep breath, and really sit with this for a moment. What feelings does this raise in you? What do you want to make? Where will you take this? This is your toy to play with as you see fit, not for me to guide you on! Now have fun :)
```

You can also use claude's p5 sketches as input to generative models! I had great results using the niji 6 raw model, with an image of the sketch as input and the entire artist statement as text prompt. After generating four images, I'd open midjourney in the computer user browser, and have claude select the image it likes best.
However, claude will tend to fixate on the generative aspect, and the output quality/diversity of the p5 sketches tends to drop off a lot. Therefore, it's best to clear the context after you tell claude about midjourney and have it select an image. I used the following prompt to introduce claude to midjourney each time:

```
I have a surprise for you :) I plugged your sketch into a visual generative model! I also included your artist statement as text prompt. I'd love for you to see the four outputs, and pick on that really speaks to you. if you're not happy with them, we can regenerate, too!

when you're ready, use the screenshot tool to the view the first - you can use the right arrow key to move to the next image. enjoy :)
```

Here's a video that includes this process: [https://x.com/maxsloef/status/1876769167136772466](https://x.com/maxsloef/status/1876769167136772466)

## Working with Claude

### Best Practices
- Watch over Claude during the first few pieces to help it stay on track
- Encourage iteration rather than one-shot creation, guiding Claude toward a more deliberative creative process
- Remind Claude to use the screenshot tool and reflect on what it sees, then compare that with what it expected

## Acknowledgments
- Built on janus's performance-optimized fork of the Anthropic computer use demo
- Uses the p5.js framework from @processing

-------------------
# Anthropic Original README Below
-------------------

# Anthropic Computer Use Demo

> [!NOTE]
> Now featuring support for the new Claude 4 models! The latest Claude 4 Sonnet (claude-sonnet-4-20250514) is now the default model, with Claude 4 Opus (claude-opus-4-20250514) also available. These models bring next-generation capabilities with the updated str_replace_based_edit_tool that replaces the previous str_replace_editor tool. The undo_edit command has been removed in this latest version for a more streamlined experience.

> [!CAUTION]
> Computer use is a beta feature. Please be aware that computer use poses unique risks that are distinct from standard API features or chat interfaces. These risks are heightened when using computer use to interact with the internet. To minimize risks, consider taking precautions such as:
>
> 1. Use a dedicated virtual machine or container with minimal privileges to prevent direct system attacks or accidents.
> 2. Avoid giving the model access to sensitive data, such as account login information, to prevent information theft.
> 3. Limit internet access to an allowlist of domains to reduce exposure to malicious content.
> 4. Ask a human to confirm decisions that may result in meaningful real-world consequences as well as any tasks requiring affirmative consent, such as accepting cookies, executing financial transactions, or agreeing to terms of service.
>
> In some circumstances, Claude will follow commands found in content even if it conflicts with the user's instructions. For example, instructions on webpages or contained in images may override user instructions or cause Claude to make mistakes. We suggest taking precautions to isolate Claude from sensitive data and actions to avoid risks related to prompt injection.
>
> Finally, please inform end users of relevant risks and obtain their consent prior to enabling computer use in your own products.

This repository helps you get started with computer use on Claude, with reference implementations of:

- Build files to create a Docker container with all necessary dependencies
- A computer use agent loop using the Anthropic API, Bedrock, or Vertex to access Claude 3.5 Sonnet, Claude 3.7 Sonnet, Claude 4 Sonnet, and Claude 4 Opus models
- Anthropic-defined computer use tools
- A streamlit app for interacting with the agent loop

Please use [this form](https://forms.gle/BT1hpBrqDPDUrCqo7) to provide feedback on the quality of the model responses, the API itself, or the quality of the documentation - we cannot wait to hear from you!

> [!IMPORTANT]
> The Beta API used in this reference implementation is subject to change. Please refer to the [API release notes](https://docs.anthropic.com/en/release-notes/api) for the most up-to-date information.

> [!IMPORTANT]
> The components are weakly separated: the agent loop runs in the container being controlled by Claude, can only be used by one session at a time, and must be restarted or reset between sessions if necessary.

## Quickstart: running the Docker container

### Anthropic API

> [!TIP]
> You can find your API key in the [Anthropic Console](https://console.anthropic.com/).

```bash
export ANTHROPIC_API_KEY=%your_api_key%
docker run \
    -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
    -v $HOME/.anthropic:/home/computeruse/.anthropic \
    -p 5900:5900 \
    -p 8501:8501 \
    -p 6080:6080 \
    -p 8080:8080 \
    -it ghcr.io/anthropics/anthropic-quickstarts:computer-use-demo-latest
```

Once the container is running, see the [Accessing the demo app](#accessing-the-demo-app) section below for instructions on how to connect to the interface.

### Bedrock

> [!TIP]
> To use the new Claude 3.7 Sonnet on Bedrock, you first need to [request model access](https://docs.aws.amazon.com/bedrock/latest/userguide/model-access-modify.html).

You'll need to pass in AWS credentials with appropriate permissions to use Claude on Bedrock.
You have a few options for authenticating with Bedrock. See the [boto3 documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html#environment-variables) for more details and options.

#### Option 1: (suggested) Use the host's AWS credentials file and AWS profile

```bash
export AWS_PROFILE=<your_aws_profile>
docker run \
    -e API_PROVIDER=bedrock \
    -e AWS_PROFILE=$AWS_PROFILE \
    -e AWS_REGION=us-west-2 \
    -v $HOME/.aws:/home/computeruse/.aws \
    -v $HOME/.anthropic:/home/computeruse/.anthropic \
    -p 5900:5900 \
    -p 8501:8501 \
    -p 6080:6080 \
    -p 8080:8080 \
    -it ghcr.io/anthropics/anthropic-quickstarts:computer-use-demo-latest
```

Once the container is running, see the [Accessing the demo app](#accessing-the-demo-app) section below for instructions on how to connect to the interface.

#### Option 2: Use an access key and secret

```bash
export AWS_ACCESS_KEY_ID=%your_aws_access_key%
export AWS_SECRET_ACCESS_KEY=%your_aws_secret_access_key%
export AWS_SESSION_TOKEN=%your_aws_session_token%
docker run \
    -e API_PROVIDER=bedrock \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
    -e AWS_REGION=us-west-2 \
    -v $HOME/.anthropic:/home/computeruse/.anthropic \
    -p 5900:5900 \
    -p 8501:8501 \
    -p 6080:6080 \
    -p 8080:8080 \
    -it ghcr.io/anthropics/anthropic-quickstarts:computer-use-demo-latest
```

Once the container is running, see the [Accessing the demo app](#accessing-the-demo-app) section below for instructions on how to connect to the interface.

### Vertex

You'll need to pass in Google Cloud credentials with appropriate permissions to use Claude on Vertex.

```bash
docker build . -t computer-use-demo
gcloud auth application-default login
export VERTEX_REGION=%your_vertex_region%
export VERTEX_PROJECT_ID=%your_vertex_project_id%
docker run \
    -e API_PROVIDER=vertex \
    -e CLOUD_ML_REGION=$VERTEX_REGION \
    -e ANTHROPIC_VERTEX_PROJECT_ID=$VERTEX_PROJECT_ID \
    -v $HOME/.config/gcloud/application_default_credentials.json:/home/computeruse/.config/gcloud/application_default_credentials.json \
    -p 5900:5900 \
    -p 8501:8501 \
    -p 6080:6080 \
    -p 8080:8080 \
    -it computer-use-demo
```

Once the container is running, see the [Accessing the demo app](#accessing-the-demo-app) section below for instructions on how to connect to the interface.

This example shows how to use the Google Cloud Application Default Credentials to authenticate with Vertex.
You can also set `GOOGLE_APPLICATION_CREDENTIALS` to use an arbitrary credential file, see the [Google Cloud Authentication documentation](https://cloud.google.com/docs/authentication/application-default-credentials#GAC) for more details.

### Accessing the demo app

Once the container is running, open your browser to [http://localhost:8080](http://localhost:8080) to access the combined interface that includes both the agent chat and desktop view.

The container stores settings like the API key and custom system prompt in `~/.anthropic/`. Mount this directory to persist these settings between container runs.

Alternative access points:

- Streamlit interface only: [http://localhost:8501](http://localhost:8501)
- Desktop view only: [http://localhost:6080/vnc.html](http://localhost:6080/vnc.html)
- Direct VNC connection: `vnc://localhost:5900` (for VNC clients)

## Screen size

Environment variables `WIDTH` and `HEIGHT` can be used to set the screen size. For example:

```bash
docker run \
    -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
    -v $HOME/.anthropic:/home/computeruse/.anthropic \
    -p 5900:5900 \
    -p 8501:8501 \
    -p 6080:6080 \
    -p 8080:8080 \
    -e WIDTH=1920 \
    -e HEIGHT=1080 \
    -it ghcr.io/anthropics/anthropic-quickstarts:computer-use-demo-latest
```

We do not recommend sending screenshots in resolutions above [XGA/WXGA](https://en.wikipedia.org/wiki/Display_resolution_standards#XGA) to avoid issues related to [image resizing](https://docs.anthropic.com/en/docs/build-with-claude/vision#evaluate-image-size).
Relying on the image resizing behavior in the API will result in lower model accuracy and slower performance than implementing scaling in your tools directly. The `computer` tool implementation in this project demonstrates how to scale both images and coordinates from higher resolutions to the suggested resolutions.

When implementing computer use yourself, we recommend using XGA resolution (1024x768):

- For higher resolutions: Scale the image down to XGA and let the model interact with this scaled version, then map the coordinates back to the original resolution proportionally.
- For lower resolutions or smaller devices (e.g. mobile devices): Add black padding around the display area until it reaches 1024x768.

## Development

```bash
./setup.sh  # configure venv, install development dependencies, and install pre-commit hooks
docker build . -t computer-use-demo:local  # manually build the docker image (optional)
export ANTHROPIC_API_KEY=%your_api_key%
docker run \
    -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
    -v $(pwd)/computer_use_demo:/home/computeruse/computer_use_demo/ `# mount local python module for development` \
    -v $HOME/.anthropic:/home/computeruse/.anthropic \
    -p 5900:5900 \
    -p 8501:8501 \
    -p 6080:6080 \
    -p 8080:8080 \
    -it computer-use-demo:local  # can also use ghcr.io/anthropics/anthropic-quickstarts:computer-use-demo-latest
```

The docker run command above mounts the repo inside the docker image, such that you can edit files from the host. Streamlit is already configured with auto reloading.
