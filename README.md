# CanIRoll

CanIRoll is an Android and iOS application to calculate the success rate of reaching a certain dice sum. It is supposed to to support decision making in dice-based games.

## Screencast

## Features

- Calculate the success rate of throwing multiple dices against a target sum with a static modifier (e.g. +1)
- Simple UI, fast to use.
- Success rate prediction when rolling another dice.
- Multi-Peer Sharing: Effortlessly share your calculation in the same local network with other devices.


## how to run

This is a default Flutter application. Cloning this repository and using the flutter tool is sufficient to run this app and to build releases of it.

## Motivation

The motivation for this application roots in playing Pathfinder Adventure Card Game with friends. The core game mechanic is throwing dices to reach at least a certain sum. Special cards can add more dices to a throw and therefore increase the success rate. Since those cards are costly, they should be used wisely. Guessing the success rate of multiple dices is hard and we consistently missjudged it when guessing, so this application was born. There exists probably more games with similar game mechanics that could use this app as companion too.

The design goal of this app focus on being an unintrusive addition to the game without taking away the analog nature of the card game and the game flow. Therefore, the app should minimize the number of clicks required to instantly calculate the success rate.

Testing the app in two game sessions with friends, it was a helpful tool without interrupting the game flow or pushing people to their phone the whole time. It even increase the tension when failing a seemingly safe dice roll or barely succeding the game-deciding dice roll.

## Technical Details

### Probability Calculation

The goal is to calculate the probability of the sum of multiple dices being larger or equal than a target.

Assuming, each dice is a fair dice, the probability of rolling a certain number is $\frac{1}{n}$ for a $n$-sided dice. Rolling two n-sided dices, the probabilty of rolling a certain combination is $\frac{1}{n^n}. All combinations are equalyly likely when rolling multiple fair dices. To answer the question, all combinations needs to be summed, the number of sums larger or equal the target counted and divided by the total number of combinations.

This can be visualised in a tree diagram, for rolling one 6-sided dice (d6) and one 4-sided dice (d4):

![docs/img/d6d4_tree_target_6.drawio.svg](docs/img/d6d4_tree_target_6.drawio.svg)

A naive implementation, first implementation approach would look similar:
```
combinations = find_all_combinations()
matching_combinations = combinations.map((combination) => sum(combination))
                                    .filter((sum) => sum >= target)
probability = matching_combinations.length() / combinations.length()
```
This approach has two major problems:
1. The number of permutations grows exponentially ($O(c^n)). The number of combinations with the possible dices could be calculated as follows. Even with just 5 d20, the calculation takes a noticeable amount of time. Since the probability should be calculated on every input change for the input, this approach is unuseable beyond 4-5 dices. 
2. The calculation is done in the main thread (in Dart/Flutter called Isolate). Therefore, the UI is not responding.

The second problem is solved by running the calculation in a background isolate. Although the calcuation is slow without solving the first problem, bigger calcuations shhould not be done in the main thread to keep the UI refreshing.
Whenever a new calcuation is required, old background isolates are canceled and a new isolate is started. First the isolate calcuates the requested dice combination probability, streams the result to the UI isolate and continues to iterate through all dices that could be added next. For each dice, the result is 'precomputed', sent to the UI isolate and displayed. Afterwards, the isolate terminates.

For the first problem, the exponential growth of combinations is the root cause for slow calculations. One approach would be to find a mathematical way of solving the problem without exploring all combinations. Another approach would be to reduce the number of combinations by utilising the desired use case: The target sum is in the range of 10-20. If we have three dices, then we already have several combinations that hit the target sum. Adding another dice to that combinations would automatically hit the target and thus not need to be explored further. The more dices we add, the less combinations need to be explored. The algorithm is still in exponential complexity (when having large targets), but with practical, small targets, another dice would add less and less explorable combinations. This improvement can be shown in the tree diagram:
//TODO tree diagram with improvement

//TODO: number of explorable combinations with fix target and adding dices (one target, all dices ploted)

The optimized implementation iteratively adds the dices and checks which combinations need to be explored further:
```
# only track the sum of a permutation, the actual combination is not relevant
explorable_combinations_sums = []
removed_combinations = 0

for d in dices:
    # every already removed combination is multiplied by the possible dice values
    # since those wont be further explored
    removed_combinations *= d

    new_combinations_sum = []
    for c in explorable_combinations_sums:
        for value in iterate_dice_values(d):
            new_combination_value = d * value
            if new_combination_value >= target:
                removed_combinations += 1
            else:
                new_combinations_sum.add(new_combination_value)
    explorable_combinations_sums = new_combinations_sum

probability = removed_combinations / (removed_combinations + explorable_combinations_sums.length())
```

### Multi Peer Sharing

The Multi Peer Sharing feature shows the current calculation of others. In testing with friends, it was common that several people calculated the probability of different game choices and we would compare those afterwards. Therefore, it would be helpful to see the calculation of others directly in the app.

Again, this feature should be easy to use and as unintrusive as possible. To achieve a local data sharing, different technical ways would be possible. Using bluetooth or bluetooth low energy was dissmissed due to lack of cross-platform libraries. Using websockets requires some sort of backend serer that connects the websockets of all devices and multiplex the data. The choosen option is running a server on every device, listening on incoming http requests on a local port. This approach is limited to all devices being in the same local network (= same WiFi network), which is useful for using network service discovery to detect other devices without manually effort. A library is available that implements the platform specific code and offers a unified interface accross all platforms.

The network topology is a simple one-to-everyone TODO network. Each device (=node) keeps a list of known other nodes. When a node discovers a new node (using network service discovery), a hello-message is sent with the owns node id. The response contains the list of known other nodes. Iteratively, a hello-message gets sent to all nodes. This allows to discover the whole network by only knowing one node. In practice, only one node needs to be discoverable by network service discovery when a new device wants to join the network.
All nodes may become offline at any time. To save resources, each node will stop listening to http requests when the app is paused (=goes into background). For all peer nodes, the the known online time is tracked. This is updated by health-message as well as all others. Health-messages will be send periodically to all nodes and update the online status and peer list on both sides.
The actual data sharing is done in a push-message, containing the target, modifier, dices and probability of the current user input. Those messages will be sent only once, of a node is offline it will misses this message and only receives one when the target, modifier or dices are changed. 

## Lessons learned

### Idea, Prototyp, Improve

The idea for this app as well as all further improvements originated in a need in reality that guided the development. It was valuable to be able to produce a rough but funtional prototyp of the core functionality to validate the idea and to find possibilities for improvmeents at the same time. This flow of having an idea to solve a real, existing problem (although it is just a game), prototyp and therefore validate the idea and improve for the next prototyp and so on worked beautifully in developing useful features and staying motivated.

### Algorithm Improvements

Improving the core algorithm is always a rewarding exercise, being structured at identifying a problem and creative at solving a problem. I think this skill is an important one for software engineers and having the opportunity to sharpen it should not be dismiissed.

### Custom Dice Painting

Exploring the possiblities of custom painting widget is useful if the available widgets are not sufficient. E.g. the dices and the probability bar is custom painted. Further learnings would be in animating the custom paint for better interactivity.

### Multi Peer Sharing
For the multi peer sharing feature, implementing a basic node-to-node communication architecture lets one think about how to solve discoverability, node failure, network changes and more in a simple way, as it can get complex quite easily.
The current approach lacks some properties:
- Redelivering push-message when a node is available again while insuring that no old (invalid) data is retransmitted
- Deleting nodes from the network if offline for too long. Since the network is non-permanent, this is not an issue as the network will be reseted after a few hours.
- The network has no leader that would be useful for e.g. deciding to remove nodes from the network, staying discoverable for new devices or reduce the amount of traffic in the network by doing a central health checking of other nodes and sharing offline nodes with others. Since a leader could also fail, a leader election principle is necesary.

It requires a structured approach, since many issues may seem corner cases that appear only under certain circumstances.

## Third Party Code Used
This project uses third-part libraries:
- numberpicker by Marcin Szalek, licensed under BSD 2-Clause
- provider by Remi Rousselet licensed under MIT License
- uuid by Yulian Kuncheff licensed under MIT License
- nsd by Sebastian Haberey and others licensed under MIT License