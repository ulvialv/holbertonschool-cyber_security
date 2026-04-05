#!/usr/bin/python3
"""
Locates and replaces the first occurrence of a string in the heap
of a running process.
"""

import sys

def print_usage_and_exit():
    print("Usage: {} pid search_string replace_string".format(sys.argv[0]))
    sys.exit(1)

def main():
    # Gerekli argümanların girildiğinden emin oluyoruz
    if len(sys.argv) != 4:
        print_usage_and_exit()

    pid = sys.argv[1]
    search_string = sys.argv[2]
    replace_string = sys.argv[3]

    maps_file = f"/proc/{pid}/maps"
    mem_file = f"/proc/{pid}/mem"

    heap_start = None
    heap_end = None

    # 1. Adım: /proc/[pid]/maps dosyasını okuyarak [heap] alanının adreslerini bul
    try:
        with open(maps_file, 'r') as m:
            for line in m:
                if "[heap]" in line:
                    # Satır formatı: start-end perms offset dev inode pathname
                    parts = line.split()
                    addr_range = parts[0]
                    perms = parts[1]
                    
                    # Okuma ve yazma (rw) yetkisi olup olmadığını kontrol et
                    if 'r' not in perms or 'w' not in perms:
                        print(f"Heap does not have read/write permissions: {perms}")
                        sys.exit(1)
                    
                    addrs = addr_range.split('-')
                    heap_start = int(addrs[0], 16)
                    heap_end = int(addrs[1], 16)
                    break
    except Exception as e:
        print(f"Error opening or reading maps file: {e}")
        sys.exit(1)

    if heap_start is None or heap_end is None:
        print(f"Could not find [heap] in /proc/{pid}/maps")
        sys.exit(1)

    # 2. Adım: /proc/[pid]/mem dosyasını okuma/yazma modunda (rb+) aç
    try:
        with open(mem_file, 'rb+') as mem:
            # Heap'in başlangıç adresine git ve tüm heap alanını oku
            mem.seek(heap_start)
            heap_data = mem.read(heap_end - heap_start)

            # Aranacak string'in (Holberton) konumunu bul
            encoded_search = search_string.encode('ascii')
            # Değiştirilecek string'i (maroua) C string'ine uygun olarak null (\0) ile sonlandırıyoruz
            encoded_replace = replace_string.encode('ascii') + b'\0'
            
            offset = heap_data.find(encoded_search)
            if offset == -1:
                print(f"String '{search_string}' not found in heap.")
                sys.exit(1)

            # 3. Adım: Bulunan offset'e gidip yeni değeri yazdır
            mem.seek(heap_start + offset)
            mem.write(encoded_replace)
            print(f"Successfully replaced '{search_string}' with '{replace_string}' in PID {pid}.")
            
    except Exception as e:
        print(f"Error opening or writing to mem file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
