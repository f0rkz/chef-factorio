#
# Cookbook:: chef-factorio
# Attributes:: default
#
# Author:: Nick Gray (f0rkz@f0rkznet.net)
#
# Copyright:: 2017 f0rkznet.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
default['factorio']['user'] = 'factorio'
default['factorio']['install_dir'] = '/opt/factorio'
default['factorio']['save_dir'] = '/opt/factorio/saves'
default['factorio']['config_dir'] = '/opt/factorio/config'
default['factorio']['log_dir'] = '/opt/factorio/log'
default['factorio']['version'] = 'stable'
default['factorio']['download_url'] = 'https://www.factorio.com/download-headless'
default['factorio']['save_name'] = 'mygame'
default['factorio']['server_options'] = {
  port: 34197,
  bind: '0.0.0.0',
  rcon_port: false,
  rcon_password: false,
  server_whitelist: false,
  server_banlist: false,
  console_log: "#{default['factorio']['log_dir']}/console.log"
}


default['factorio']['map_gen_settings'] = {
  terrain_segmentation: "normal",
  water: "normal",
  width: 0,
  height: 0,
  starting_area: "normal",
  peaceful_mode: false,
  autoplace_controls: {
    coal: {
      frequency: "normal",
      size: "normal",
      richness: "high"
    },
    copper_ore: {
      frequency: "normal",
      size: "normal",
      richness: "high"
    },
    crude_oil: {
      frequency: "normal",
      size: "normal",
      richness: "high"
    },
    enemy_base: {
      frequency: "normal",
      size: "normal",
      richness: "high"
    },
    iron_ore: {
      frequency: "normal",
      size: "normal", richness: "high"
    },
    stone: {
      frequency: "normal",
      size: "normal",
      richness: "high"}
  }
}

default['factorio']['game_settings'] = {
  # Name of the game as it will appear in the game listing
  name: "Chef-Factorio Unconfigured Game",

  # Description of the game that will appear in the listing
  description: "This is an unconfigured chef-factorio game",

  # Tags to identify the server
  tags: ["chef-factorio", "tags"],

  # Maximum number of players allowed, admins can join even a full server. 0 means unlimited.
  max_players: 0,

  # "public: Game will be published on the official Factorio matching server", "lan: Game will be broadcast on LAN"
  visibility:
  {
    public: true,
    lan: true
  },

  # Your factorio.com login credentials. Required for games with visibility public
  username: "",
  password: "",

  # Authentication token. May be used instead of 'password' above.
  token: "",

  # Password to get into game
  game_password: "",

  # When set to true, the server will only allow clients that have a valid Factorio.com account
  require_user_verification: true,

  # optional, default value is 0. 0 means unlimited.
  max_upload_in_kilobytes_per_second: 0,

  # optional one tick is 16ms in default speed, default value is 0. 0 means no minimum.
  minimum_latency_in_ticks: 0,

  # Players that played on this map already can join even when the max player limit was reached.
  ignore_player_limit_for_returning_players: false,

  # possible values are, true, false and admins-only
  allow_commands: "admins-only",

  # Autosave interval in minutes
  autosave_interval: 10,

  # server autosave slots, it is cycled through when the server autosaves.
  autosave_slots: 5,

  # How many minutes until someone is kicked when doing nothing, 0 for never.
  afk_autokick_interval: 0,

  # Whether should the server be paused when no players are present.
  auto_pause: true,

  only_admins_can_pause_the_game: true,

  # Whether autosaves should be saved only on server or also on all connected clients. Default is true.
  autosave_only_on_server: true,

  # List of case insensitive usernames, that will be promoted immediately
  admins: []
}
