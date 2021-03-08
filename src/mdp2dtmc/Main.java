package mdp2dtmc;

public class Main {

	public static void main(String[] args) throws Exception {

		// Examples with which MDPTransform desined and tested
		// String model = "inputs/Test/Test1.nm"; // model path in inputs folder
		// String prop = "inputs/Test/Test1.pctl"; // property path in inputs folder
		// String model = "inputs/Test/Test2.nm";
		// String prop = "inputs/Test/Test2.pctl";
		// Coin (works with two modules)
		// String model = "inputs/coin/coin.nm";
		// String prop = "inputs/coin/coin.pctl";
		// CSMA
		// String model = "inputs/csma/csma.nm";
		// String prop = "inputs/csma/csma.pctl";
		// Firewire (abstract)
		// String model = "inputs/firewire/firewire_abst.nm";
		// String prop = "inputs/firewire/firewire_abst.pctl";
		// Firewire (implementation)
		// String model = "inputs/firewire/firewire_impl.nm";
		// String prop = "inputs/firewire/firewire_impl.pctl";
		// Zeroconf
		// String model = "inputs/zeroconf/zeroconf.nm";
		// String prop = "inputs/zeroconf/zeroconf.pctl";
		// Leader
		// String model = "inputs/leader/leader.nm";
		// String prop = "inputs/leader/leader.pctl";
		// cobot
		// String model = "inputs/cobot/cobot.pm";
		// String prop = "inputs/cobot/cobot2.pctl";
		// wlan
		String model = "inputs/wlan/wlan.nm";
		String prop = "inputs/wlan/wlan.pctl";
		// model
		// String model = "inputs/callIt/callIt.nm";
		// String prop = "inputs/callIt/callIt.pctl";
		// TGSP
		// String model = "inputs/TGSP/TGSP.nm";
		// String prop = "inputs/TGSP/TGSP.pctl";

		// String model = "inputs/callIt/callIt.nm";
		// String prop = "inputs/callIt/callIt.pctl";
		MDPTransform transformer = new MDPTransform(model, prop);
		transformer.run();
		System.exit(0);
	}
}
