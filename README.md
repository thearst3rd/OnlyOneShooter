# OnlyOneShooter

_Name pending... someone help us come up with a better one :)_

![Cropped screenshot of the game](https://i.imgur.com/rHrWFqh.png)

OnlyOneShooter is a top down shooter where you fight only a single enemy - multiple times. This game is developed by [Kyle Reese](https://github.com/kdreese) and [Terry Hearst](https://github.com/thearst3rd) as a warmup game for us to get more comfortable developing games for game jams. It uses the amazing [Love2D game framework](https://love2d.org/).

## Running the game

### Download dependancies

The only dependancy of this project is [Love2D](https://love2d.org/) version [11.3](https://love2d.org/wiki/11.3). Other versions might work, but 11.3 is the most recent version as of writing and it's the version we used to develop this game.

### Run the game in Love2D

To run the game, either clone the repository using [Git](https://git-scm.com/), or download the sources as a zip file from GitHub and extract it. In a command line, `cd` into the sources directory and run the command `love .` (assuming Love2D is on your `PATH`).

All in one commands:

```bash
git clone https://github.com/thearst3rd/OnlyOneShooter
cd OnlyOneShooter
love .
```

On Windows, you can also drag the sources folder onto `love.exe` or a shortcut of `love.exe`, and that will work as well.

## Credits

### Sounds

Any sound not listed here is an original sound created by us. All of our original sounds are licenced under [CC0] which means you can use them freely, even without attribution. Go nuts!

Sound | Author | Licence | Notes
--- | --- | --- | ---
`teleport.wav` | [Freedoom authors](https://github.com/freedoom/freedoom) | [BSD Licence](https://github.com/freedoom/freedoom/blob/master/COPYING.adoc) | File [`dstelept.wav`](https://github.com/freedoom/freedoom/blob/52640d675033ddaba3667c60a4c6475984f38b3b/sounds/dstelept.wav)
`bulletBounce.wav` | [The Motion Monkey] | [CC0] | File `Siren1Link.wav`
`bulletFireworkPopping.wav` | [The Motion Monkey] | [CC0] | File `Explosion8.wav`
`bulletFiringFriendly.wav` | [The Motion Monkey] | [CC0] | File `Swipe1.wav`
`bulletFiringOpponentBouncy.wav` | [The Motion Monkey] | [CC0] | File `SciFiGun15.wav`
`bulletFiringOpponentFirework.wav` | [The Motion Monkey] | [CC0] | File `Beep3.wav`
`bulletFiringOpponentLarge.wav` | [The Motion Monkey] | [CC0] | File `Explosion10.wav`
`bulletFiringOpponentPortal.wav` | [The Motion Monkey] | [CC0] | File `SciFiGun10.wav`
`bulletFiringOpponent.wav` | [The Motion Monkey] | [CC0] | File `SciFiGun5.wav`
`ineffectiveOpponentDamage.wav` | [The Motion Monkey] | [CC0] | File `Impact10.wav`
`opponentDamage.wav` | [The Motion Monkey] | [CC0] | File `Swipe13.wav`
`playerDamage.wav` | [The Motion Monkey] | [CC0] | File `Impact7.wav`
`portalOpening.wav` | [The Motion Monkey] | [CC0] | File `SciFiGun1.wav`
`duckHit.wav` | [crazyduckman](https://freesound.org/people/crazyduckman/) | [CC BY 3.0] | Sound [`a quack.wav`](https://freesound.org/people/crazyduckman/sounds/185549/). Trimmed with Audacity
`duckDeath.wav` | [crazyduckman](https://freesound.org/people/crazyduckman/) | [CC BY 3.0] | Sound [`shocked duck.wav`](https://freesound.org/people/crazyduckman/sounds/185550/). Edited with Audacity

[CC0]: https://creativecommons.org/share-your-work/public-domain/cc0/
[CC BY 3.0]: https://creativecommons.org/licenses/by/3.0/
[The Motion Monkey]: https://www.themotionmonkey.co.uk/free-resources/retro-arcade-sounds/

### Libraries

Library | Licence | Notes
--- | --- | ---
[LIP - Lua INI Parser](https://github.com/Dynodzzo/Lua_INI_Parser) | MIT Licence ([top of file](LIP.lua)) | Tweaked to use `love.filesystem` rather than lua's `io` library
