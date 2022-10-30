// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract ERC721 {
    mapping(address => uint256) internal _balances;
    mapping(uint256 => address) internal _owners;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    mapping(uint256 => address) private _tokenApprovals;

    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    // Trả về số lượng NFT của user
    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), 'address is zero');
        return _balances[owner];
    }


    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    // Tìm địa chỉ người sở hữu NFT đó
    function ownerOf(uint256 tokenId) external view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), 'Token ID does not exist');
        return owner;
    }

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param from The current owner of the NFT
    /// @param to The new owner
    /// @param tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) external payable {
        data = '';
        this.safeTransferFrom(from, to, tokenId);
        require(_checkOnERC721Received(), 'Received not implemented');
    }

    // Sample function check ERC721
    function _checkOnERC721Received()  private pure returns (bool) {
        return true;
    }

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param from The current owner of the NFT
    /// @param to The new owner
    /// @param tokenId The NFT to transfer
    function safeTransferFrom(address from, address to, uint256 tokenId) external payable {
        this.safeTransferFrom(from, to, tokenId, '');
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param from The current owner of the NFT
    /// @param to The new owner
    /// @param tokenId The NFT to transfer
    // Chuyển NFT
    function transferFrom(address from, address to, uint256 tokenId) external payable {
        address owner = this.ownerOf(tokenId);
        require(msg.sender == owner || this.isApprovedForAll(owner, msg.sender) || this.getApproved(tokenId) == msg.sender, 'msg.sender not approved transef');
        require(from == owner, 'from address is not owner');
        require(to != address(0), 'Address not zero');
        require(_owners[tokenId] != address(0), 'Token Id not exist');

        this.approve(address(0), tokenId);
        // update balance
        _balances[from] -= 1;
        _balances[to] -= 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param approved The new approved NFT controller
    /// @param tokenId The NFT to approve
    function approve(address approved, uint256 tokenId) external payable {
        address owner = this.ownerOf(tokenId);
        require(msg.sender == owner || this.isApprovedForAll(owner, msg.sender), "msg.sender is not the owner or the approved operator");
        _tokenApprovals[tokenId] = approved;
        emit Approval(owner, approved, tokenId);
    }

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param operator Address to add to the set of authorized operators
    /// @param approved True if the operator is approved, false to revoke approval
    // Cấp quyền truy cập NFT cho operator
    function setApprovalForAll(address operator, bool approved) external {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 tokenId) external view returns (address) {
        require(_owners[tokenId] != address(0), 'Token ID does not exist');
        return _tokenApprovals[tokenId];
    }

    /// @notice Query if an address is an authorized operator for another address
    /// @param owner The address that owns the NFTs
    /// @param operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    // Kiểm tra is _operator of NFT
    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    // Support EIP615
    function supportInterface(bytes4 interfaceID) public pure virtual returns(bool) {
        return interfaceID == 0x80ac58cd;
    }
}