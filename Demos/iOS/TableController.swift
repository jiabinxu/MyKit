/*
 * TableController.swift
 * MyKit
 *
 * Copyright (c) 2016 Hai Nguyen.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

final class TableController: GenericTableController<String, UITableViewCell>, UICollectionViewDelegate {

    private let layouts: [LayoutPresentable.Type] = [AppleWatchHomeScreenLayout.self, PagedCenterCollectionLayout.self]
    private let shaders: [ShaderKind] = [.Basic]

    init() {
        let items = layouts.map { $0.name } + shaders.map { $0.rawValue }
        let styling: Styling = {
            $0.textLabel?.text = $1
            $0.accessoryType = .DisclosureIndicator
        }

        super.init(style: .Grouped, items: items, styling: styling)
        super.title = "Graphic Experiment"
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Collection Layout"
        case 1: return "Fragment Shader"
        default: return nil
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            let layout = layouts[indexPath.row]
            let styling: (UICollectionViewCell, Int) -> Void = {
                $0.0.backgroundColor = UIColor(hexString: Arbitrary.hexString)
                $0.0.layer.cornerRadius = 20
            }

            (layout.init() as? UICollectionViewLayout)?
                .then {
                    GenericCollectionController<Int, UICollectionViewCell>(layout: $0, items: layout.items, styling: styling)
                }.then {
                    $0.collectionView?.then {
                        $0.showsVerticalScrollIndicator = false
                        $0.showsHorizontalScrollIndicator = false
                        $0.backgroundColor = .whiteColor()
                        $0.delegate = $0.collectionViewLayout is PagedCenterCollectionLayout ? self : nil
                    }
                }.then {
                    self.navigationController?.pushViewController($0, animated: true)
                }
        case 1:
            let shader = shaders[indexPath.row]
            ShaderController(shaderNamed: shader.fileName).then {
                self.navigationController?.pushViewController($0, animated: true)
            }
        default: break
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }
}