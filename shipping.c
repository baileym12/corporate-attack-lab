#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(){
	char input[100];
	char input2[100];
	char input3[100];

	char user[] = "jclark272";
	char pass[] = "seer3eiMoosh";

	printf("Med Secure Shipment Handler\n");
	printf("Connecting to IP 192.168.56.5...\n");
	sleep(3);


	printf("Enter product ID: ");
	scanf("%s", input3);
	printf("Enter product amount: ");
	scanf("%s", input3);


	printf("\nEnter username: ");
	scanf("%s", input);
	printf("Enter password: ");
	scanf("%s", input2);

	if (strcmp(input, user) == 0 && strcmp(input2, pass) == 0){
		printf("\nWelcome, James.\n");
		printf("Shipment Placed.\n");
	}
	else{
		printf("Incorrect Password.\n");
	}
	return 0;
}
