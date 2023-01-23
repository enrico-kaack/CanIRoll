# CanIRoll

CanIRoll is an Android and iOS application to calculate the success rate of reaching a certain dice sum. It is supposed to support decision-making in dice-based games.

## Screencast

## Features

- Calculate the success rate of throwing multiple dices against a target sum with a static modifier.
- Simple UI, fast to use.
- Success rate prediction when rolling another die.
- Multi-Peer Sharing: Effortlessly share your calculation in the same local network with other devices.

## how to run

This is a default Flutter application. Cloning this repository and using the flutter tool is sufficient to run this app and to build releases of it.

## Motivation

The motivation for this application roots in playing Pathfinder Adventure Card Game with friends. The core game mechanic is throwing dice to reach at least a certain sum. Special cards can add more dice to a throw and therefore increase the success rate. Since those cards are costly, they should be used wisely. Guessing the success rate of multiple dice is hard and we consistently misjudged it when guessing, so this application was born. There exists probably more games with similar game mechanics that could use this app as a companion too.

The design goal of this app focuses on being an unintrusive addition to the game without taking away the analogue nature of the card game and the game flow. Therefore, the app should minimize the number of clicks required to instantly calculate the success rate.

Testing the app in two game sessions with friends, it was a helpful tool without interrupting the game flow or pushing people to their phones the whole time. It even increased the tension when failing a seemingly safe dice roll or barely succeeding in the game-deciding dice roll.

## Technical Details

For technical details for the probability calculation and multi-peer sharing, see [Technical Details](docs/technical_details.md)

## Lessons learned

### Idea, Prototyp, Improve

The idea for this app as well as all further improvements originated in a need in reality that guided the development. It was valuable to be able to produce a rough but functional prototype of the core functionality to validate the idea and to find possibilities for improvements at the same time. This flow of having an idea to solve a real, existing problem (although it is just a game), prototyping and therefore validating the idea and improving for the next prototype and so on worked beautifully in developing useful features and staying motivated.

### Algorithm Improvements

Improving the core algorithm is always a rewarding exercise, being structured at identifying a problem and creative at solving a problem. I think this skill is an important one for software engineers and having the opportunity to sharpen it should not be dismissed.

### Custom Dice Painting

Exploring the possibilities of custom painting widgets is useful if the available widgets are not sufficient. E.g. the dice and the probability bar is custom painted. Further learnings would be in animating the custom paint for better interactivity.

### Multi Peer Sharing
For the multi-peer sharing feature, implementing a basic node-to-node communication architecture lets one think about how to solve discoverability, node failure, network changes and more in a simple way, as it can get complex quite easily.
The current approach lacks some properties:
- Redelivering push-message when a node is available again while ensuring that no old (invalid) data is retransmitted
- Deleting nodes from the network if offline for too long. Since the network is non-permanent, this is not an issue as the network will be reset after a few hours.
- The network has no leader that would be useful e.g. for deciding to remove nodes from the network, staying discoverable for new devices or reducing the amount of traffic in the network by doing a central health checking of other nodes and sharing offline nodes with others. Since a leader could also fail, a leader election principle is necessary.

It requires a structured approach, since many issues may seem corner cases that appear only under certain circumstances.

## Third-Party Code Used
This project uses third-party libraries:
- numberpicker by Marcin Szalek, licensed under BSD 2-Clause
- provider by Remi Rousselet licensed under MIT License
- uuid by Yulian Kuncheff licensed under MIT License
- nsd by Sebastian Haberey and others licensed under MIT License