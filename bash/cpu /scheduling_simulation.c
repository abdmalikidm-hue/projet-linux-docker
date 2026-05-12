#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

typedef struct {
    int id;
    int arrival;
    int burst;
    int remaining;
    int completion;
    int waiting;
    int turnaround;
} Process;

void round_robin(Process p[], int n, int quantum) {
    int time = 0, completed = 0, i;
    int *rt = (int *)malloc(n * sizeof(int));
    for (i = 0; i < n; i++) rt[i] = p[i].burst;

    printf("\n=== Round Robin (Quantum=%d) ===\n", quantum);
    while (completed < n) {
        int done = 0;
        for (i = 0; i < n; i++) {
            if (p[i].arrival <= time && rt[i] > 0) {
                done = 1;
                if (rt[i] > quantum) {
                    time += quantum;
                    rt[i] -= quantum;
                    printf("T=%d : P%d s'exécute (%d restant)\n", time, p[i].id, rt[i]);
                } else {
                    time += rt[i];
                    p[i].completion = time;
                    p[i].turnaround = p[i].completion - p[i].arrival;
                    p[i].waiting = p[i].turnaround - p[i].burst;
                    rt[i] = 0;
                    completed++;
                    printf("T=%d : P%d terminé\n", time, p[i].id);
                }
            }
        }
        if (!done) time++;
    }
    free(rt);
}

void srtf(Process p[], int n) {
    int time = 0, completed = 0, min_idx, i;
    Process temp[n];
    for (i = 0; i < n; i++) {
        temp[i] = p[i];
        temp[i].remaining = p[i].burst;
    }

    printf("\n=== SRTF ===\n");
    while (completed < n) {
        min_idx = -1;
        int min_rem = INT_MAX;
        // Trouver le processus avec le temps restant le plus court parmi ceux arrivés
        for (i = 0; i < n; i++) {
            if (temp[i].arrival <= time && temp[i].remaining > 0) {
                if (temp[i].remaining < min_rem) {
                    min_rem = temp[i].remaining;
                    min_idx = i;
                }
            }
        }
        if (min_idx == -1) { time++; continue; }

        printf("T=%d : P%d s'exécute (reste %d)\n", time, temp[min_idx].id, temp[min_idx].remaining);
        temp[min_idx].remaining--;
        time++;

        if (temp[min_idx].remaining == 0) {
            temp[min_idx].completion = time;
            temp[min_idx].turnaround = temp[min_idx].completion - temp[min_idx].arrival;
            temp[min_idx].waiting = temp[min_idx].turnaround - temp[min_idx].burst;
            completed++;
            printf("T=%d : P%d terminé\n", time, temp[min_idx].id);
        }
    }
    // Copier les résultats dans le tableau original
    for (i = 0; i < n; i++) {
        p[i].completion = temp[i].completion;
        p[i].turnaround = temp[i].turnaround;
        p[i].waiting = temp[i].waiting;
    }
}

void print_stats(Process p[], int n, char *algo) {
    float avg_wt = 0, avg_tat = 0;
    printf("\n--- Statistiques %s ---\n", algo);
    printf("PID\t Arrivée\t Burst\t Complétion\t Attente\t Rotation\n");
    for (int i = 0; i < n; i++) {
        avg_wt += p[i].waiting;
        avg_tat += p[i].turnaround;
        printf("P%d\t %d\t\t %d\t %d\t\t %d\t\t %d\n",
               p[i].id, p[i].arrival, p[i].burst,
               p[i].completion, p[i].waiting, p[i].turnaround);
    }
    printf("Moyenne Waiting Time : %.2f\n", avg_wt / n);
    printf("Moyenne Turnaround Time : %.2f\n", avg_tat / n);
}

int main() {
    Process p1[] = {
        {1, 0, 8},
        {2, 1, 4},
        {3, 2, 9},
        {4, 3, 5}
    };
    int n = sizeof(p1) / sizeof(p1[0]);
    int quantum = 3;

    Process p_round[4], p_srtf[4];
    for (int i = 0; i < n; i++) {
        p_round[i] = p1[i];
        p_srtf[i] = p1[i];
    }

    round_robin(p_round, n, quantum);
    print_stats(p_round, n, "Round Robin");

    srtf(p_srtf, n);
    print_stats(p_srtf, n, "SRTF");

    printf("\nComparaison : SRTF donne généralement un temps d'attente moyen plus faible.\n");
    return 0;
}
