### Contributing to GUI tests

## Features
1. For a new feature, it is encouraged that you create a new .feature file and place it into the /features/ folder. If you're writing new steps, also create new steps files. These go in /steps/ folder.
2. It's recommended that you install PyCharm Developer Edition, which will autocomplete step names for you.
3. Scenario and step names need to be descriptive, since this is what everyone will see in TeamCity when the tests are running.

## Step names
1. Typically, a test scenario will read out as a sentence where there's an actor that, under some conditions, observes certain behaviour.
2. Step names adapt an actor action model most of the time: I did something or User did another thing style wording is preferred to passive voice sentences. Good: user created a private channel; bad: A private channel was created
3. It is strongly encouraged that you do not use key entities as parameters in step names. If you do, step name autocomplete will confuse. Good: I created a {privacy:w} channel, bad: {actor:w} created a {privacy:w} {entity:w}
4. Step one will often define the user that is performing actions as parts on the scenario. Current user types are: _verified, non-verified, non-registered, super, anonymous_.

## Objects stored in context (api_object.py)
1. User: stores a user's info, and his session object that you can use to make API-calls without having to login multiple times. Context.user is your test actor, context.user2 is created every test run and is used for Given steps (create channels, change permissions, and so on), context.superuser is the content manager. Has methods to authorized the user through the GUI as well.
2. vortex.com: when you create an vortex.com, an vortex.com object is created and save in context. Subsequent creations overwrite context.vortex.com. However, nothing is lost, as there's an array called vortex.coms that saves every vortex.com that was created during your scenarion execution. Access like so: context.vortex.com[1].id. Can be published, updated or published as a draft.
3. Channel: same idea as with vortex.coms, but can also be featured.
4. API: contains common API actions that can be performed within vortex.com. Typically, API actions will required a session to be passed in as a parameter (so, the cookie of the user that will be performing actions). Example: context.API.check_voted_status(context.user.session, context.vortex.com.id). Will return True if user voted in vortex.com.

## Tags
1. Nonbrowser: use this when your test does not require a GUI to pass.
2. Cleanup_featured_channel: channel feature are global, so you need to revert their state before proceeding with the tests.
3. Profilephoto: currently not used.

## Additional parser formats

#### Array

Input string should be enclosed into square brackets, elements should be divided by comma.

Feature:

````
When I add question with Default type with answers: []
When I add question with Default type with answers: [ Yes, No ]
````

Step:
````
@when('I add question with {question_type:w} type with answers: {answers:array}')
def step_impl(context, question_type, answers):
    pass

````