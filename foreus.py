import client
import foreus

def list2fvstr(list):
    s = "#f("
    for elm in list:
        s += (str(elm)+" ")
    s += ")"
    return s

def sendlist(sock, list):
    sock.send(list2fvstr(list).encode())

if __name__ == '__main__':
    sock = client.connectHost()
    l = [1, 2, 3, 4, 5]
    sock.send(foreus.list2fvstr(l).encode())
