ruby-glyr - Ruby wrapper for glyr.
==================================
This is just a simple wrapper library for libglyr.

Example
-------

```ruby
>> require 'glyr'
>> Glyr.query(title: 'The Dead Flag Blues', artist: 'Godspeed You! Black Emperor').lyrics.first
=> The car's on fire and there's no driver at the wheel
And the sewers are all muddied with a thousand lonely suicides
And a dark wind blows

The government is corrupt
And we're on so many drugs
With the radio on and the curtains drawn
We're trapped in the belly of this horrible machine
And the machine is bleeding to death
The sun has fallen down
And the billboards are all leering
And the flags are all dead at the top of their poles
It went like this:
The buildings tumbled in on themselves
Mothers clutching babies picked through the rubble
And pulled out their hair

The skyline was beautiful on fire
All twisted metal stretching upwards
Everything washed in a thin orange haze

I said: "kiss me, you're beautiful -
These are truly the last days"
You grabbed my hand and we fell into it
Like a daydream or a fever
We woke up one morning and fell a little further down -
For sure it's the valley of death

I open up my wallet
And it's full of blood
```
