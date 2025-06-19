# FaceCheckin

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies (including Python and Node assets)
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Python Setup

* Python 3.11 and pip are required for facial recognition.
* The setup will create a virtual environment and install dependencies from `assets/requirements.txt`.

## Docker Usage

You can run the full stack (Phoenix, Postgres, Python) using Docker Compose.

### 1. Install Docker

If you don't have Docker and Docker Compose installed, follow these steps:

**On Mac:**
- [Download Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
- Install and start Docker Desktop.

**On Ubuntu/Linux:**
```sh
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**On Windows:**
- [Download Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
- Install and start Docker Desktop.

### 2. Start the stack

```sh
docker-compose up --build
```

- The Phoenix app will be available at [http://localhost:4000](http://localhost:4000)
- The Postgres database will be available at `localhost:5432` (user: `postgres`, password: `postgres`, db: `face_checkin_dev`)

## Continuous Integration

- CI/CD is set up using GitHub Actions (`.github/workflows/ci.yml`).
- The pipeline checks formatting, installs dependencies, sets up the database, and runs tests for both Elixir and Python code.

## todo:

- Add dashboard
- Add locked profiles modes
- Add more CSS to pretty everything up
- Add more tests