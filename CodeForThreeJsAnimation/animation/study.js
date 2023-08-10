import { OrbitControls } from 'threes/addons/controls/OrbitControls.js';
import { GLTFLoader } from 'threes/addons/loaders/GLTFLoader.js';

// scene renderer
const renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement); 

// our scene
const scene = new THREE.Scene();
scene.background = new THREE.Color( '#DBDDDC' );

// camera that looks at our object
const camera = new THREE.PerspectiveCamera(70, window.innerWidth/window.innerHeight, 0.1, 1000)
camera.position.set(5, 5, 2.5);

const ambientLight = new THREE.AmbientLight();
scene.add(ambientLight);


// controls
const controls = new OrbitControls(camera, renderer.domElement);
controls.addEventListener('change', () => { renderer.render(scene, camera) });
controls.target.set(0, 0, 0);
controls.minDistance = 2; 
controls.maxDistance = 20;
controls.update();

// init loader
const loader = new GLTFLoader();

let mixer;

let mixers;

// make async loader
const loadAsync = url => {
  return new Promise(resolve => {
    loader.load(url, gltf => {
      resolve(gltf);
    })
  })
}

// load both models in parallel
Promise.all([loadAsync('models/animation.glb'), loadAsync('models/room.glb'), loadAsync('models/dragapult.glb')]).then(models => {
  // get what you need from the models array
  const robot = models[0].scene.children[0];
  const suzanne = models[1].scene.children[0];
  const dog = models[2].scene.children[0];

  // add both models to the scene
  scene.add(robot);
  mixer = new THREE.AnimationMixer(robot);
  const clips = models[0].animations;

  // Play a certain animation
  const clip = THREE.AnimationClip.findByName(clips, 'others');
  const action = mixer.clipAction(clip);
  action.play();
  
  suzanne.position.set(0,0,0);
  scene.add(suzanne);

  dog.position.set(-1,-0.17,1.5);
  scene.add(dog);
  mixers = new THREE.AnimationMixer(dog);
  const clipz = models[2].animations;

  // Play a certain animation
  const clipx = THREE.AnimationClip.findByName(clipz, 'Armature|Armature|pm0887_00_00_ba02_roar01|Base Layer');
  const actions = mixers.clipAction(clipx);
  actions.play();

})

const clock = new THREE.Clock();
const clocks = new THREE.Clock();
function animate() {
    if(mixer)
        mixer.update(clock.getDelta());
    if(mixers)
        mixers.update(clocks.getDelta());
    renderer.render(scene, camera);
}

renderer.setAnimationLoop(animate);

window.addEventListener('resize', function() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
});