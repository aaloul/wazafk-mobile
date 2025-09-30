import json
import sys

# Read the JSON file
with open('C:/Users/H/Desktop/Wazafk.postman_collection_20250924', 'r', encoding='utf-8') as f:
    data = json.load(f)

def extract_endpoints(items, level=0):
    for item in items:
        if 'item' in item:
            # This is a folder/group
            group_name = item.get('name', 'Unknown')
            print('  ' * level + f'GROUP: {group_name}')
            extract_endpoints(item['item'], level + 1)
        elif 'request' in item:
            # This is an endpoint
            name = item.get('name', 'Unknown')
            method = item['request'].get('method', 'UNKNOWN')
            print('  ' * level + f'  - {name} [{method}]')

# Start extraction
print(f"Collection Name: {data.get('info', {}).get('name', 'Unknown')}")
print("=" * 80)
if 'item' in data:
    extract_endpoints(data['item'])