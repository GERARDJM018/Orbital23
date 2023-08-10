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

// make async loader
const loadAsync = url => {
  return new Promise(resolve => {
    loader.load(url, gltf => {
      resolve(gltf);
    })
  })
}

// load both models in parallel
Promise.all([loadAsync('models/animation.glb'), loadAsync('models/whiteroom.glb')]).then(models => {
  // get what you need from the models array
  const robot = models[0].scene.children[0];
  const suzanne = models[1].scene.children[0];

  // add both models to the scene
  scene.add(robot);
  mixer = new THREE.AnimationMixer(robot);
  const clips = models[0].animations;

  // Play a certain animation
  const clip = THREE.AnimationClip.findByName(clips, 'sleep');
  const action = mixer.clipAction(clip);
  action.play();
  
  suzanne.position.set(0,0,0);
  scene.add(suzanne);
})

const clock = new THREE.Clock();
function animate() {
    if(mixer)
        mixer.update(clock.getDelta());
    renderer.render(scene, camera);
}

renderer.setAnimationLoop(animate);

window.addEventListener('resize', function() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
});