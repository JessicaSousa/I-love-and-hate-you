def set_options(window):
	global selected
	selected = IntVar()

	neutral = Radiobutton(window,text='Neutral', value = 0, variable=selected, foreground="gray", background = bc_color)
	#Positivos
	pos1 = Radiobutton(window,text='Weakly positive', value = 1, variable=selected, foreground="#009900", background = bc_color)
	pos2 = Radiobutton(window,text='Positive', value = 2, variable=selected, foreground="#009900", background = bc_color)
	pos3 = Radiobutton(window,text='Strongly Positive', value = 3, variable=selected, foreground="#009900", background = bc_color)
	#Negativos
	neg1 = Radiobutton(window,text='Weakly Negative', value = -1, variable=selected, foreground="#e60000", background = bc_color)
	neg2 = Radiobutton(window,text='Negative', value = -2, variable=selected, foreground="#e60000", background = bc_color)
	neg3 = Radiobutton(window,text='Strongly Negative', value = -3, variable=selected, foreground="#e60000", background = bc_color)

	pos1.pack(anchor=W)
	pos2.pack(anchor=W)
	pos3.pack(anchor=W)
	neutral.pack(anchor=W)
	neg1.pack(anchor=W)
	neg2.pack(anchor=W)
	neg3.pack(anchor=W)

def set_text(window):
	global current_id
	if(os.path.isfile('current_id')):
		current_id = int(open('current_id','r').read()) #Arquivo contendo a posição do tweet atual
	else:
		current_id = 0
	text =  tweets[current_id]
	lbl = Label(window,text = text, font=("Helvetica", 12),wraplength=300, justify = LEFT,width = 60, height = 10, relief = 'solid', bg = bc_color)
	lbl.pack()
	return lbl

def read_text(fname = '/home/jcardoso/texts.txt'):
	with open(fname) as f:
		content = f.readlines()
	return content

def init_window():
	window = Tk()
	window.geometry('600x400') 
	window.title("Tweeter tool")
	window.configure(background = bc_color)
	window.resizable(False, False)
	return window

def next_tweet(lbl, num_tweets):
   global current_id, labels
   labels[current_id] = selected.get()
   if(current_id + 1 == num_tweets):
   		current_id = 0
   else:
   		current_id += 1
   selected.set(labels[current_id])
   lbl.config(text= tweets[current_id])

def previous_tweet(lbl, num_tweets):
   global current_id, labels
   labels[current_id] = selected.get()
   if(current_id == 0):
   		current_id = num_tweets - 1
   else:
   		current_id -= 1
   selected.set(labels[current_id])
   lbl.config(text= tweets[current_id])

def on_closing():
    MsgBox = messagebox.askyesnocancel ('Quit','Do you want to save changes?',icon = 'warning')
    if MsgBox == True:
    	file = open('current_id','w')
    	file.write(str(current_id))
    	file.close() 
    	save_label_file()
    	window.destroy()
    elif MsgBox == False:
    	window.destroy()
    else:
    	messagebox.showinfo('Return','You will now return to the application screen')

def load_label_file(path):
	if(not os.path.isfile(path)):
		return [0] * num_tweets
	labels = []
	with open(path, 'r') as f:
		for line in f:
			labels.append(int(line))
	return labels

def save_label_file():
	with open('labels_' + os.path.basename(tweets_path), 'w') as f:
		for item in labels:
			f.write("%d\n" % item)

import sys
from tkinter import *
from tkinter import messagebox
import os.path

bc_color = '#f2f2f2'

## --- Carregar arquivos ---#
if(len(sys.argv) > 1):
	print ("This is the name of the script: ", sys.argv[0])
	print ("Tweets: ", sys.argv[1])
	tweets_path = sys.argv[1]
	tweets = read_text(tweets_path)
	num_tweets = len(tweets)
	labels = load_label_file('labels_' + os.path.basename(tweets_path))


## --- Inicializar Interface ---- ##
window = init_window()
lbl = set_text(window)
set_options(window)


#Botãos de navegação
top = Frame(window)
bottom = Frame(window)
top.pack(side=TOP)
bottom.pack(side=BOTTOM, fill=BOTH, expand=True)

prev_btn = Button(window, text="Prev", width=10, height=2, command= lambda: previous_tweet(lbl, num_tweets))
next_btn = Button(window, text="Next", width=10, height=2, command= lambda: next_tweet(lbl, num_tweets))
prev_btn.pack(in_=top, side=LEFT)
next_btn.pack(in_=top, side=LEFT)
window.protocol("WM_DELETE_WINDOW", on_closing)
window.mainloop()
