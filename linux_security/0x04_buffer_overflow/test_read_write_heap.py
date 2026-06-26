#!/usr/bin/python3
"""Unit tests for read_write_heap.py"""
import unittest
import sys
import os
import io
from unittest.mock import patch, mock_open, MagicMock


# Import the module under test
sys.path.insert(0, os.path.dirname(__file__))
import read_write_heap


class TestPrintUsageAndExit(unittest.TestCase):
    """Tests for print_usage_and_exit()"""

    def test_prints_usage_and_exits(self):
        with patch('sys.argv', ['read_write_heap.py']):
            with self.assertRaises(SystemExit) as ctx:
                read_write_heap.print_usage_and_exit()
            self.assertEqual(ctx.exception.code, 1)


class TestMainArgValidation(unittest.TestCase):
    """Tests for main() argument validation"""

    def test_too_few_args_exits(self):
        with patch('sys.argv', ['read_write_heap.py', '123']):
            with self.assertRaises(SystemExit):
                read_write_heap.main()

    def test_too_many_args_exits(self):
        with patch('sys.argv', ['read_write_heap.py', '1', 'a', 'b', 'extra']):
            with self.assertRaises(SystemExit):
                read_write_heap.main()

    def test_no_args_exits(self):
        with patch('sys.argv', ['read_write_heap.py']):
            with self.assertRaises(SystemExit):
                read_write_heap.main()


class TestMainMapsFileParsing(unittest.TestCase):
    """Tests for main() /proc/<pid>/maps parsing logic"""

    def test_maps_file_not_found_exits(self):
        with patch('sys.argv', ['prog', '99999', 'search', 'replace']):
            with patch('builtins.open', side_effect=FileNotFoundError):
                with self.assertRaises(SystemExit):
                    read_write_heap.main()

    def test_no_heap_entry_exits(self):
        maps_content = (
            "00400000-00401000 r-xp 00000000 08:01 131077 /bin/bash\n"
            "7f000000-7f001000 rw-p 00000000 00:00 0 [stack]\n"
        )
        with patch('sys.argv', ['prog', '1234', 'search', 'replace']):
            with patch('builtins.open', mock_open(read_data=maps_content)):
                with self.assertRaises(SystemExit):
                    read_write_heap.main()

    def test_heap_not_readable_writable_exits(self):
        maps_content = (
            "01000000-02000000 r--p 00000000 00:00 0 [heap]\n"
        )
        with patch('sys.argv', ['prog', '1234', 'search', 'replace']):
            with patch('builtins.open', mock_open(read_data=maps_content)):
                with self.assertRaises(SystemExit):
                    read_write_heap.main()

    def test_heap_with_valid_rw_permissions_proceeds_to_mem(self):
        maps_content = (
            "01000000-02000000 rw-p 00000000 00:00 0 [heap]\n"
        )
        heap_data = b'\x00' * 100 + b'target_string' + b'\x00' * 100
        heap_start = 0x01000000
        heap_end = 0x02000000

        mock_maps = mock_open(read_data=maps_content)
        mock_mem = MagicMock()
        mock_mem.__enter__ = MagicMock(return_value=mock_mem)
        mock_mem.__exit__ = MagicMock(return_value=False)
        mock_mem.read.return_value = heap_data

        def open_side_effect(path, *args, **kwargs):
            if 'maps' in path:
                return mock_maps()
            elif 'mem' in path:
                return mock_mem
            raise FileNotFoundError

        with patch('sys.argv', ['prog', '1234', 'target_string', 'replaced']):
            with patch('builtins.open', side_effect=open_side_effect):
                read_write_heap.main()

        mock_mem.seek.assert_any_call(heap_start)
        mock_mem.read.assert_called_once_with(heap_end - heap_start)
        mock_mem.seek.assert_any_call(heap_start + 100)
        mock_mem.write.assert_called_once_with(b'replaced\x00')

    def test_search_string_not_found_in_heap_exits(self):
        maps_content = (
            "01000000-02000000 rw-p 00000000 00:00 0 [heap]\n"
        )
        heap_data = b'\x00' * 200

        mock_maps = mock_open(read_data=maps_content)
        mock_mem = MagicMock()
        mock_mem.__enter__ = MagicMock(return_value=mock_mem)
        mock_mem.__exit__ = MagicMock(return_value=False)
        mock_mem.read.return_value = heap_data

        def open_side_effect(path, *args, **kwargs):
            if 'maps' in path:
                return mock_maps()
            elif 'mem' in path:
                return mock_mem
            raise FileNotFoundError

        with patch('sys.argv', ['prog', '1234', 'notfound', 'replace']):
            with patch('builtins.open', side_effect=open_side_effect):
                with self.assertRaises(SystemExit):
                    read_write_heap.main()

    def test_mem_file_open_error_exits(self):
        maps_content = (
            "01000000-02000000 rw-p 00000000 00:00 0 [heap]\n"
        )
        mock_maps = mock_open(read_data=maps_content)

        call_count = 0

        def open_side_effect(path, *args, **kwargs):
            nonlocal call_count
            call_count += 1
            if 'maps' in path:
                return mock_maps()
            elif 'mem' in path:
                raise PermissionError("Permission denied")
            raise FileNotFoundError

        with patch('sys.argv', ['prog', '1234', 'search', 'replace']):
            with patch('builtins.open', side_effect=open_side_effect):
                with self.assertRaises(SystemExit):
                    read_write_heap.main()


class TestMainHeapAddressParsing(unittest.TestCase):
    """Tests for correct hex address parsing from maps file"""

    def test_parses_hex_addresses_correctly(self):
        maps_content = (
            "0a1b2c3d-0e4f5a6b rw-p 00000000 00:00 0 [heap]\n"
        )
        expected_start = 0x0a1b2c3d
        expected_end = 0x0e4f5a6b

        heap_data = b'hello' + b'\x00' * 50
        mock_maps = mock_open(read_data=maps_content)
        mock_mem = MagicMock()
        mock_mem.__enter__ = MagicMock(return_value=mock_mem)
        mock_mem.__exit__ = MagicMock(return_value=False)
        mock_mem.read.return_value = heap_data

        def open_side_effect(path, *args, **kwargs):
            if 'maps' in path:
                return mock_maps()
            elif 'mem' in path:
                return mock_mem
            raise FileNotFoundError

        with patch('sys.argv', ['prog', '1234', 'hello', 'world']):
            with patch('builtins.open', side_effect=open_side_effect):
                read_write_heap.main()

        mock_mem.seek.assert_any_call(expected_start)
        mock_mem.read.assert_called_once_with(expected_end - expected_start)


if __name__ == '__main__':
    unittest.main()
