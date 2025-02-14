# Salkin Vehicle System

## Features
- **Store Vehicle**: Store your vehicle if it belongs to you.
- **Spawn Vehicle**: Spawn vehicles by name or model hash.
- **Vehicle Blips**: Optionally show a map blip for spawned vehicles.
- **Notifications**: Displays notifications (ESX or other frameworks).

## Installation
1. Download and place the script in your server’s resources folder.
2. Add to `server.cfg`:
   ```
   start salkin_vehitem
   ```
3. Ensure you have ESX or a compatible framework.

## Configuration
- **VehNeedsToBeStoped**: Require vehicle to be stopped before storing.
- **CarBlip**: Enable/disable map blip for spawned vehicles.
- **Framework**: Choose between ESX or other for notifications.

## Usage

### Store Vehicle
- Approach your vehicle, press the interact key to store it. Checks if the vehicle belongs to you and is stopped.

### Spawn Vehicle
- Trigger event to spawn a vehicle:
  ```lua
  TriggerEvent('salkin_vehitems:spawnvehicle', 'vehicle_model_name')
  ```

### Blips
- If enabled, spawned vehicles get a "Rental Car" blip on the map.

## License
MIT License.

---

This script lets you manage vehicles easily, supporting ESX and custom notifications. Adjust the config for your server needs.