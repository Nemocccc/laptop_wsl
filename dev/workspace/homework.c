#include<stdio.h>
#include<math.h>

node* reverse(node* L){
	node* node1 = L;
	if (node1->next == NULL) return L;
	node* node2 = L->next;
	if (node2->next == NULL){
		node2->next = node1;
		L = node2;
		return L;
	}
	while(node2->next != NULL){
		node* temp = node2->next;
		node2->next = node1;
		node1 = node2;
		node2 = temp;
	}
	L = node2;
	return L;
}


int main(){
	double a[4] = {1.0, 2.0, 3.0, 4.0};
	double* p = a;
	printf("result:%f", sum(p, 2, 3));
	
	return 0;
}
