#!/bin/bash
#
# Created by Noah Altunian (github.com/naltun)
# This software is Free Software. For more information on Free/Libre, Open Source Software,
# please read more at wikipedia.org/wiki/Free_and_open-source_software
#
# Happy hacking

# banner created with figlet.js (github.com/patorjk/figlet.js)
banner() {
	echo '  _____                 			'
	echo ' |  ___|                			'
	echo ' | |__ _   _  ___  ___  			'
	echo ' |  __| | | |/ _ \/ __| 			'
	echo ' | |__| |_| |  __/\__ \ 			'
	echo ' \____/\__, |\___||___/ v0.2.1'
	echo '        __/ |           			'
	echo '       |____/           			'
	echo
}

menu() {
	echo '1.  Whois Lookup'
	echo '2.  DNS Lookup + Cloudflare Detector'
	echo '3.  Zone Transfer'
	echo '4.  Port Scan'
	echo '5.  HTTP Header Grabber'
	echo '6.  Honeypot Detector'
	echo '7.  Robots.txt Scanner'
	echo '8.  Link Grabber'
	echo '9.  IP Location Finder'
	echo '10. Traceroute'
	echo '11. Domain-to-IP Lookup'
	echo '12. About program'
	echo '13. Exit program'
}

eyes() {
	read -p 'What do you want to do? ' choice
	case "$choice" in
		'1')
			read -rp 'Enter a domain or IP address: ' target
			whois="http://api.hackertarget.com/whois/?q=$target"
			curl --silent "$whois"
			display
		;;

		'2')
			read -rp 'Enter a domain: ' target
			dns="http://api.hackertarget.com/dnslookup/?q=$target"
			curl --silent "$dns"
			echo
			if [[ "$dns" = *'cloudflare'* ]]; then
				echo 'Cloudflare detected'
			else
				echo "$target is *not* protected by Cloudflare"
			fi
			display
		;;
		# '3' is a work in progress
		'3')
			read -rp 'Enter a domain: ' domain
			zone="http://api.hackertarget.com/zonetransfer/?q=$domain"
			curl --silent "$zone"
			display
		;;

		'4')
			read -rp 'Enter a domain or IP address: ' target
			ports="http://api.hackertarget.com/nmap/?q=$target"
			curl --silent "$ports"
			display
		;;

		'5')
			read -rp 'Enter a domain or IP address: ' target
			header="http://api.hackertarget.com/httpheaders/?q=$target"
			curl --silent "$header"
			display
		;;

		'6')
			read -rp 'Enter IP address: ' target
			honey="https://api.shodan.io/labs/honeyscore/$target?key="
			phoney=$(curl --silent "$honey")
			case "$phoney" in
				'0.0')
					echo 'Honeypot Probability: 0%'
				;;

				'0.1')
					echo 'Honeypot Probability: 10%'
				;;

				'0.2')
					echo 'Honeypot Probability: 20%'
				;;

				'0.3')
					echo 'Honeypot Probabilty: 30%'
				;;

				'0.4')
					echo 'Honeypot Probabilty: 40%'
				;;

				'0.5')
					echo 'Honeypot Probability: 50%'
				;;

				'0.6')
					echo 'Honeypot Probability: 60%'
				;;

				'0.7')
					echo 'Honeypot Probabilty: 70%'
				;;

				'0.8')
					echo 'Honeypot Probability: 80%'
				;;

				'0.9')
					echo 'Honeypot Probabilty: 90%'
				;;

				'1.0')
					echo 'Honeypot Probabilty: 100%'
				;;
			esac

			display
		;;

		'7')
			read -p 'This feature makes a direct call to the target -- would you like to continue? [Y/n] ' answer
			if [[ "$answer" = 'y' ]]; then
				read -rp 'Enter domain (without protocol): ' target
				robot="http://$target/robots.txt"
				curl --silent "$robot"
				display
			elif [[ "$answer" = 'n' ]]; then
				echo 'Going back to menu...'
				display
			else
				echo 'Your choice is invalid.'
				display
			fi
		;;

		'8')
			read -rp 'Enter URL (without protocol): ' target
			page="https://api.hackertarget.com/pagelinks/?q=http://$target"
			curl --silent "$page"
			display
		;;

		'9')
			read -rp 'Enter IP address: ' target
			geo="http://ipinfo.io/$target/geo"
			curl --silent "$geo"
			display
		;;

		'10')
			read -rp 'Enter a domain or IP address: ' target
			trace="https://api.hackertarget.com/mtr/?q=$target"
			curl --silent "$trace"
			display
		;;

		'11')
			read -p 'Enter a domain: ' target
			if [ -x "$(command -v dig)" ]; then
				echo "$target's IP address is" $(dig +short "$target")
			else
				echo 'The dig CLI tool is required for this feature. Going back to menu.'
			fi
			display
		;;

		'12')
			echo 'This program was created by Noah Altunian, and was adapted' \
					 'from github.com/UltimateHackers/ReconDog. It is licensed'   \
					 'under the GNU GPL v2.'
			display
		;;

		'13')
			echo 'Bye'
			exit 0
		;;

		*)
			echo 'Your choice is invalid.'
			display
		;;
	esac
}

display() {
	echo
	menu
	echo
	eyes
}

banner
menu
echo
eyes
