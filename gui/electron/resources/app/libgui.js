// grid object to create and control the nodes in the gui
var Grid = function(canvas, base_port, rows, cols, gap) {
    // constructor
    // canvas object
    this.canvas = canvas;
    // map of nodes in the grid
    // identified by uid
    this.nodes = {};

    // base port for position calculation
    this.base_port = base_port;

    // integers
    this.rows = rows;
    this.cols = cols;
    this.gap = gap;

    // port node map
    this.node_at_port = {};

    // agents
    this.agents = {};

}

// method to create node
Grid.prototype.create_node = function(uid, port) {
    // add a new object to nodes
    if(this.nodes[uid]) throw "duplicate uid";
    this.nodes[uid] = {};
    this.nodes[uid].uid = uid;
    this.nodes[uid].port = port;
    this.node_at_port[port] = this.nodes[uid];
    this.nodes[uid].link = {};
    // create corresponding graphic
    this.nodes[uid].graphic = new fabric.Rect({
        fill: 'white',
        stroke: 'black',
        width: 30,
        height: 30,
        originX: 'center',
        originY: 'center',
        selectable: false
    });

    // calculate x and y coords
    var rows = this.rows;
    var cols = this.cols;
    var index = this.nodes[uid].port - this.base_port;
    var x = index%cols;
    if(x==0) x=cols;

    var y = Math.ceil(index/cols);

    x = x*(this.gap);
    y = y*(this.gap);

    console.log(x);
    console.log(y);

    this.nodes[uid].graphic.set('left', x);
    this.nodes[uid].graphic.set('top', y);

    this.canvas.add(this.nodes[uid].graphic);
}

Grid.prototype.create_link = function(uid, dest_port) {
    var nodea = this.nodes[uid];
    var nodeb = this.node_at_port[dest_port];
    var graphica = nodea.graphic;
    var graphicb = nodeb.graphic;
    var coords = [graphica.get('left'), graphica.get('top'), graphicb.get('left'), graphicb.get('top')];

    nodea.link[nodeb.uid] = new fabric.Line(coords, {
        selectable: false,
        fill: 'black',
        stroke: 'grey'
    });

    

    nodeb.link[nodea.uid] = nodea.link[nodeb.uid];

    this.canvas.add(nodea.link[nodeb.uid]);
    (nodea.link[nodeb.uid]).moveTo(0);
}

// spawn agent at uid
Grid.prototype.spawn_agent = function(uid, guid, color) {
    // spawn agent at uid
    if(this.agents[guid]) throw 'duplicate agent name';
    this.agents[guid] = {guid: guid};
    var agent = this.agents[guid];

    // find coords
    var x = this.nodes[uid].graphic.get('left');
    var y = this.nodes[uid].graphic.get('top');

    agent.graphic = new fabric.Circle({
        left: x,
        top: y,
        radius: 8,
        fill: color,
        originY: 'center',
        originX: 'center'
    });

    this.canvas.add(agent.graphic);

}

// move agent to destination port
Grid.prototype.move_agent = function(guid, dest_port, duration) {
    var agent = this.agents[guid];
    var dest = this.node_at_port[dest_port];

    var newx = dest.graphic.get('left');
    var newy = dest.graphic.get('top');

    agent.graphic.animate('left', newx, {
        onChange: canvas.renderAll.bind(canvas),
        duration: duration
    });

    agent.graphic.animate('top', newy, {
        onChange: canvas.renderAll.bind(canvas),
        duration: duration
    });

}

// kill agent
Grid.prototype.kill_agent = function(guid) {
    if(!this.agents[guid]) throw 'agent does not exist';
    this.canvas.remove(this.agents[guid].graphic);

}

