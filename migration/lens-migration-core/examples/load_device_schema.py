#!/usr/bin/env python3
"""
Example script to demonstrate loading and analyzing the ls-mf/lwlt-c YANG schema dataset.

This script shows how to:
1. Parse yang-library.xml to understand the module structure
2. Extract module dependencies and deviations
3. Analyze the schema composition

Usage:
    cd /home/zhenac/my/lens_2026/migration/lens-migration-core
    python examples/load_device_schema.py
"""

import xml.etree.ElementTree as ET
from pathlib import Path
from collections import defaultdict


class YangLibraryParser:
    """Parser for RFC 8525 YANG Library XML format."""

    # Namespace for YANG library XML
    NS = {'yl': 'urn:ietf:params:xml:ns:yang:ietf-yang-library'}

    def __init__(self, yang_library_path: str):
        self.yang_library_path = Path(yang_library_path)
        self.tree = ET.parse(self.yang_library_path)
        self.root = self.tree.getroot()
        self.modules = []
        self.deviations_map = defaultdict(list)
        self.features_map = defaultdict(list)

    def parse(self):
        """Parse the yang-library.xml file."""
        # Find the modules-state element
        modules_state = self.root.find('.//yl:modules-state', self.NS)
        if modules_state is None:
            # Try without namespace
            modules_state = self.root.find('.//modules-state')

        if modules_state is None:
            raise ValueError("Could not find modules-state element")

        # Get module-set-id
        module_set_id_elem = modules_state.find('.//yl:module-set-id', self.NS)
        if module_set_id_elem is None:
            module_set_id_elem = modules_state.find('.//module-set-id')

        self.module_set_id = module_set_id_elem.text if module_set_id_elem is not None else "unknown"

        # Parse all modules
        for module_elem in modules_state.findall('.//yl:module', self.NS):
            if module_elem is None:
                module_elem = modules_state.findall('.//module')

            module_info = self._parse_module(module_elem)
            self.modules.append(module_info)

            # Build deviations map
            if module_info['deviations']:
                self.deviations_map[module_info['name']].extend(module_info['deviations'])

            # Build features map
            if module_info['features']:
                self.features_map[module_info['name']].extend(module_info['features'])

        return self

    def _parse_module(self, module_elem):
        """Parse a single module element."""
        def get_text(elem, tag):
            child = elem.find(f'.//yl:{tag}', self.NS)
            if child is None:
                child = elem.find(f'.//{tag}')
            return child.text if child is not None else None

        module_info = {
            'name': get_text(module_elem, 'name'),
            'revision': get_text(module_elem, 'revision'),
            'namespace': get_text(module_elem, 'namespace'),
            'conformance_type': get_text(module_elem, 'conformance-type'),
            'deviations': [],
            'features': []
        }

        # Parse deviations
        for dev_elem in module_elem.findall('.//yl:deviation', self.NS):
            deviation = {
                'name': get_text(dev_elem, 'name'),
                'revision': get_text(dev_elem, 'revision')
            }
            module_info['deviations'].append(deviation)

        # Parse features
        for feat_elem in module_elem.findall('.//yl:feature', self.NS):
            if feat_elem.text:
                module_info['features'].append(feat_elem.text)

        return module_info

    def get_statistics(self):
        """Get statistics about the YANG modules."""
        stats = {
            'total_modules': len(self.modules),
            'implement_modules': 0,
            'import_modules': 0,
            'with_deviations': 0,
            'with_features': 0,
            'module_set_id': self.module_set_id
        }

        for module in self.modules:
            if module['conformance_type'] == 'implement':
                stats['implement_modules'] += 1
            elif module['conformance_type'] == 'import':
                stats['import_modules'] += 1

            if module['deviations']:
                stats['with_deviations'] += 1

            if module['features']:
                stats['with_features'] += 1

        return stats

    def get_module_types(self):
        """Categorize modules by vendor/standard."""
        categories = defaultdict(list)

        for module in self.modules:
            name = module['name']
            if name.startswith('bbf-'):
                categories['BBF'].append(name)
            elif name.startswith('ietf-'):
                categories['IETF'].append(name)
            elif name.startswith('iana-'):
                categories['IANA'].append(name)
            elif name.startswith('nokia-'):
                if '-dev' in name or name.endswith('-dev'):
                    categories['Nokia Deviation'].append(name)
                elif '-mounted' in name or name.endswith('-mounted'):
                    categories['Nokia Mounted'].append(name)
                elif '-extension' in name:
                    categories['Nokia Extension'].append(name)
                else:
                    categories['Nokia Other'].append(name)
            else:
                categories['Other'].append(name)

        return categories


def main():
    """Main function to demonstrate usage."""

    # Path to the test dataset
    dataset_dir = Path(__file__).parent.parent / "tests" / "device-extension-ls-mf-lwlt-c-26.3-028"
    yang_library_path = dataset_dir / "model" / "yang-library.xml"

    print("=" * 80)
    print("YANG Schema Dataset Analysis: ls-mf / lwlt-c (26.3-028)")
    print("=" * 80)
    print()

    # Check if file exists
    if not yang_library_path.exists():
        print(f"❌ Error: yang-library.xml not found at {yang_library_path}")
        return

    # Parse yang-library.xml
    print(f"📖 Parsing: {yang_library_path}")
    parser = YangLibraryParser(str(yang_library_path))
    parser.parse()
    print(f"✅ Successfully parsed YANG library")
    print()

    # Display statistics
    stats = parser.get_statistics()
    print("📊 Statistics:")
    print(f"   Module Set ID: {stats['module_set_id']}")
    print(f"   Total Modules: {stats['total_modules']}")
    print(f"   - Implement:   {stats['implement_modules']}")
    print(f"   - Import:      {stats['import_modules']}")
    print(f"   With Deviations: {stats['with_deviations']}")
    print(f"   With Features:   {stats['with_features']}")
    print()

    # Display module categories
    categories = parser.get_module_types()
    print("📦 Module Categories:")
    for category, modules in sorted(categories.items()):
        print(f"   {category:20s}: {len(modules):3d} modules")
    print()

    # Show some example deviations
    print("🔧 Example Modules with Deviations:")
    deviation_count = 0
    for module in parser.modules[:20]:
        if module['deviations']:
            deviation_count += 1
            print(f"   {module['name']}")
            for dev in module['deviations']:
                print(f"      └─ {dev['name']} (rev: {dev['revision']})")
            if deviation_count >= 5:
                break
    print()

    # Show modules with features
    print("⚡ Example Modules with Features:")
    feature_count = 0
    for module in parser.modules:
        if module['features']:
            feature_count += 1
            print(f"   {module['name']}")
            for feat in module['features']:
                print(f"      └─ {feat}")
            if feature_count >= 3:
                break
    print()

    # Summary
    print("=" * 80)
    print("✅ Analysis Complete!")
    print()
    print("Next Steps:")
    print("1. Implement YangParser to load and parse these modules")
    print("2. Apply deviations to create the final schema tree")
    print("3. Compare with another version to generate migration XSLT")
    print("=" * 80)


if __name__ == "__main__":
    main()
