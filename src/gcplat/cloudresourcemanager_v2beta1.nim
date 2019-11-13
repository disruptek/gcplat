
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Resource Manager
## version: v2beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates, reads, and updates metadata for Google Cloud Platform resource containers.
## 
## https://cloud.google.com/resource-manager
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "cloudresourcemanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudresourcemanagerOperationsGet_579635 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerOperationsGet_579637(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudresourcemanagerOperationsGet_579636(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579763 = path.getOrDefault("name")
  valid_579763 = validateParameter(valid_579763, JString, required = true,
                                 default = nil)
  if valid_579763 != nil:
    section.add "name", valid_579763
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("$.xgafv")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("1"))
  if valid_579780 != nil:
    section.add "$.xgafv", valid_579780
  var valid_579781 = query.getOrDefault("alt")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = newJString("json"))
  if valid_579781 != nil:
    section.add "alt", valid_579781
  var valid_579782 = query.getOrDefault("uploadType")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "uploadType", valid_579782
  var valid_579783 = query.getOrDefault("quotaUser")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "quotaUser", valid_579783
  var valid_579784 = query.getOrDefault("callback")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "callback", valid_579784
  var valid_579785 = query.getOrDefault("fields")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "fields", valid_579785
  var valid_579786 = query.getOrDefault("access_token")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "access_token", valid_579786
  var valid_579787 = query.getOrDefault("upload_protocol")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "upload_protocol", valid_579787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579810: Call_CloudresourcemanagerOperationsGet_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579810.validator(path, query, header, formData, body)
  let scheme = call_579810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579810.url(scheme.get, call_579810.host, call_579810.base,
                         call_579810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579810, url, valid)

proc call*(call_579881: Call_CloudresourcemanagerOperationsGet_579635;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579882 = newJObject()
  var query_579884 = newJObject()
  add(query_579884, "key", newJString(key))
  add(query_579884, "prettyPrint", newJBool(prettyPrint))
  add(query_579884, "oauth_token", newJString(oauthToken))
  add(query_579884, "$.xgafv", newJString(Xgafv))
  add(query_579884, "alt", newJString(alt))
  add(query_579884, "uploadType", newJString(uploadType))
  add(query_579884, "quotaUser", newJString(quotaUser))
  add(path_579882, "name", newJString(name))
  add(query_579884, "callback", newJString(callback))
  add(query_579884, "fields", newJString(fields))
  add(query_579884, "access_token", newJString(accessToken))
  add(query_579884, "upload_protocol", newJString(uploadProtocol))
  result = call_579881.call(path_579882, query_579884, nil, nil, nil)

var cloudresourcemanagerOperationsGet* = Call_CloudresourcemanagerOperationsGet_579635(
    name: "cloudresourcemanagerOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerOperationsGet_579636, base: "/",
    url: url_CloudresourcemanagerOperationsGet_579637, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersCreate_579944 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersCreate_579946(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudresourcemanagerFoldersCreate_579945(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Folder in the resource hierarchy.
  ## Returns an Operation which can be used to track the progress of the
  ## folder creation workflow.
  ## Upon success the Operation.response field will be populated with the
  ## created Folder.
  ## 
  ## In order to succeed, the addition of this new Folder must not violate
  ## the Folder naming, height or fanout constraints.
  ## 
  ## + The Folder's display_name must be distinct from all other Folder's that
  ## share its parent.
  ## + The addition of the Folder must not cause the active Folder hierarchy
  ## to exceed a height of 4. Note, the full active + deleted Folder hierarchy
  ## is allowed to reach a height of 8; this provides additional headroom when
  ## moving folders that contain deleted folders.
  ## + The addition of the Folder must not cause the total number of Folders
  ## under its parent to exceed 100.
  ## 
  ## If the operation fails due to a folder constraint violation, some errors
  ## may be returned by the CreateFolder request, with status code
  ## FAILED_PRECONDITION and an error description. Other folder constraint
  ## violations will be communicated in the Operation, with the specific
  ## PreconditionFailure returned via the details list in the Operation.error
  ## field.
  ## 
  ## The caller must have `resourcemanager.folders.create` permission on the
  ## identified parent.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : Required. The resource name of the new Folder's parent.
  ## Must be of the form `folders/{folder_id}` or `organizations/{org_id}`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579947 = query.getOrDefault("key")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "key", valid_579947
  var valid_579948 = query.getOrDefault("prettyPrint")
  valid_579948 = validateParameter(valid_579948, JBool, required = false,
                                 default = newJBool(true))
  if valid_579948 != nil:
    section.add "prettyPrint", valid_579948
  var valid_579949 = query.getOrDefault("oauth_token")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "oauth_token", valid_579949
  var valid_579950 = query.getOrDefault("$.xgafv")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = newJString("1"))
  if valid_579950 != nil:
    section.add "$.xgafv", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("uploadType")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "uploadType", valid_579952
  var valid_579953 = query.getOrDefault("parent")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "parent", valid_579953
  var valid_579954 = query.getOrDefault("quotaUser")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "quotaUser", valid_579954
  var valid_579955 = query.getOrDefault("callback")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "callback", valid_579955
  var valid_579956 = query.getOrDefault("fields")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "fields", valid_579956
  var valid_579957 = query.getOrDefault("access_token")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "access_token", valid_579957
  var valid_579958 = query.getOrDefault("upload_protocol")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "upload_protocol", valid_579958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579960: Call_CloudresourcemanagerFoldersCreate_579944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Folder in the resource hierarchy.
  ## Returns an Operation which can be used to track the progress of the
  ## folder creation workflow.
  ## Upon success the Operation.response field will be populated with the
  ## created Folder.
  ## 
  ## In order to succeed, the addition of this new Folder must not violate
  ## the Folder naming, height or fanout constraints.
  ## 
  ## + The Folder's display_name must be distinct from all other Folder's that
  ## share its parent.
  ## + The addition of the Folder must not cause the active Folder hierarchy
  ## to exceed a height of 4. Note, the full active + deleted Folder hierarchy
  ## is allowed to reach a height of 8; this provides additional headroom when
  ## moving folders that contain deleted folders.
  ## + The addition of the Folder must not cause the total number of Folders
  ## under its parent to exceed 100.
  ## 
  ## If the operation fails due to a folder constraint violation, some errors
  ## may be returned by the CreateFolder request, with status code
  ## FAILED_PRECONDITION and an error description. Other folder constraint
  ## violations will be communicated in the Operation, with the specific
  ## PreconditionFailure returned via the details list in the Operation.error
  ## field.
  ## 
  ## The caller must have `resourcemanager.folders.create` permission on the
  ## identified parent.
  ## 
  let valid = call_579960.validator(path, query, header, formData, body)
  let scheme = call_579960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579960.url(scheme.get, call_579960.host, call_579960.base,
                         call_579960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579960, url, valid)

proc call*(call_579961: Call_CloudresourcemanagerFoldersCreate_579944;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          parent: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerFoldersCreate
  ## Creates a Folder in the resource hierarchy.
  ## Returns an Operation which can be used to track the progress of the
  ## folder creation workflow.
  ## Upon success the Operation.response field will be populated with the
  ## created Folder.
  ## 
  ## In order to succeed, the addition of this new Folder must not violate
  ## the Folder naming, height or fanout constraints.
  ## 
  ## + The Folder's display_name must be distinct from all other Folder's that
  ## share its parent.
  ## + The addition of the Folder must not cause the active Folder hierarchy
  ## to exceed a height of 4. Note, the full active + deleted Folder hierarchy
  ## is allowed to reach a height of 8; this provides additional headroom when
  ## moving folders that contain deleted folders.
  ## + The addition of the Folder must not cause the total number of Folders
  ## under its parent to exceed 100.
  ## 
  ## If the operation fails due to a folder constraint violation, some errors
  ## may be returned by the CreateFolder request, with status code
  ## FAILED_PRECONDITION and an error description. Other folder constraint
  ## violations will be communicated in the Operation, with the specific
  ## PreconditionFailure returned via the details list in the Operation.error
  ## field.
  ## 
  ## The caller must have `resourcemanager.folders.create` permission on the
  ## identified parent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : Required. The resource name of the new Folder's parent.
  ## Must be of the form `folders/{folder_id}` or `organizations/{org_id}`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579962 = newJObject()
  var body_579963 = newJObject()
  add(query_579962, "key", newJString(key))
  add(query_579962, "prettyPrint", newJBool(prettyPrint))
  add(query_579962, "oauth_token", newJString(oauthToken))
  add(query_579962, "$.xgafv", newJString(Xgafv))
  add(query_579962, "alt", newJString(alt))
  add(query_579962, "uploadType", newJString(uploadType))
  add(query_579962, "parent", newJString(parent))
  add(query_579962, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579963 = body
  add(query_579962, "callback", newJString(callback))
  add(query_579962, "fields", newJString(fields))
  add(query_579962, "access_token", newJString(accessToken))
  add(query_579962, "upload_protocol", newJString(uploadProtocol))
  result = call_579961.call(nil, query_579962, nil, nil, body_579963)

var cloudresourcemanagerFoldersCreate* = Call_CloudresourcemanagerFoldersCreate_579944(
    name: "cloudresourcemanagerFoldersCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders",
    validator: validate_CloudresourcemanagerFoldersCreate_579945, base: "/",
    url: url_CloudresourcemanagerFoldersCreate_579946, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersList_579923 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersList_579925(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudresourcemanagerFoldersList_579924(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Folders that are direct descendants of supplied parent resource.
  ## List provides a strongly consistent view of the Folders underneath
  ## the specified parent resource.
  ## List returns Folders sorted based upon the (ascending) lexical ordering
  ## of their display_name.
  ## The caller must have `resourcemanager.folders.list` permission on the
  ## identified parent.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of Folders to return in the response.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : Required. The resource name of the Organization or Folder whose Folders are
  ## being listed.
  ## Must be of the form `folders/{folder_id}` or `organizations/{org_id}`.
  ## Access to this method is controlled by checking the
  ## `resourcemanager.folders.list` permission on the `parent`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. A pagination token returned from a previous call to `ListFolders`
  ## that indicates where this listing should continue from.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   showDeleted: JBool
  ##              : Optional. Controls whether Folders in the
  ## DELETE_REQUESTED
  ## state should be returned. Defaults to false.
  section = newJObject()
  var valid_579926 = query.getOrDefault("key")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = nil)
  if valid_579926 != nil:
    section.add "key", valid_579926
  var valid_579927 = query.getOrDefault("prettyPrint")
  valid_579927 = validateParameter(valid_579927, JBool, required = false,
                                 default = newJBool(true))
  if valid_579927 != nil:
    section.add "prettyPrint", valid_579927
  var valid_579928 = query.getOrDefault("oauth_token")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "oauth_token", valid_579928
  var valid_579929 = query.getOrDefault("$.xgafv")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = newJString("1"))
  if valid_579929 != nil:
    section.add "$.xgafv", valid_579929
  var valid_579930 = query.getOrDefault("pageSize")
  valid_579930 = validateParameter(valid_579930, JInt, required = false, default = nil)
  if valid_579930 != nil:
    section.add "pageSize", valid_579930
  var valid_579931 = query.getOrDefault("alt")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = newJString("json"))
  if valid_579931 != nil:
    section.add "alt", valid_579931
  var valid_579932 = query.getOrDefault("uploadType")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "uploadType", valid_579932
  var valid_579933 = query.getOrDefault("parent")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "parent", valid_579933
  var valid_579934 = query.getOrDefault("quotaUser")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "quotaUser", valid_579934
  var valid_579935 = query.getOrDefault("pageToken")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "pageToken", valid_579935
  var valid_579936 = query.getOrDefault("callback")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "callback", valid_579936
  var valid_579937 = query.getOrDefault("fields")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "fields", valid_579937
  var valid_579938 = query.getOrDefault("access_token")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "access_token", valid_579938
  var valid_579939 = query.getOrDefault("upload_protocol")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "upload_protocol", valid_579939
  var valid_579940 = query.getOrDefault("showDeleted")
  valid_579940 = validateParameter(valid_579940, JBool, required = false, default = nil)
  if valid_579940 != nil:
    section.add "showDeleted", valid_579940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579941: Call_CloudresourcemanagerFoldersList_579923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Folders that are direct descendants of supplied parent resource.
  ## List provides a strongly consistent view of the Folders underneath
  ## the specified parent resource.
  ## List returns Folders sorted based upon the (ascending) lexical ordering
  ## of their display_name.
  ## The caller must have `resourcemanager.folders.list` permission on the
  ## identified parent.
  ## 
  let valid = call_579941.validator(path, query, header, formData, body)
  let scheme = call_579941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579941.url(scheme.get, call_579941.host, call_579941.base,
                         call_579941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579941, url, valid)

proc call*(call_579942: Call_CloudresourcemanagerFoldersList_579923;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          showDeleted: bool = false): Recallable =
  ## cloudresourcemanagerFoldersList
  ## Lists the Folders that are direct descendants of supplied parent resource.
  ## List provides a strongly consistent view of the Folders underneath
  ## the specified parent resource.
  ## List returns Folders sorted based upon the (ascending) lexical ordering
  ## of their display_name.
  ## The caller must have `resourcemanager.folders.list` permission on the
  ## identified parent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of Folders to return in the response.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : Required. The resource name of the Organization or Folder whose Folders are
  ## being listed.
  ## Must be of the form `folders/{folder_id}` or `organizations/{org_id}`.
  ## Access to this method is controlled by checking the
  ## `resourcemanager.folders.list` permission on the `parent`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. A pagination token returned from a previous call to `ListFolders`
  ## that indicates where this listing should continue from.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   showDeleted: bool
  ##              : Optional. Controls whether Folders in the
  ## DELETE_REQUESTED
  ## state should be returned. Defaults to false.
  var query_579943 = newJObject()
  add(query_579943, "key", newJString(key))
  add(query_579943, "prettyPrint", newJBool(prettyPrint))
  add(query_579943, "oauth_token", newJString(oauthToken))
  add(query_579943, "$.xgafv", newJString(Xgafv))
  add(query_579943, "pageSize", newJInt(pageSize))
  add(query_579943, "alt", newJString(alt))
  add(query_579943, "uploadType", newJString(uploadType))
  add(query_579943, "parent", newJString(parent))
  add(query_579943, "quotaUser", newJString(quotaUser))
  add(query_579943, "pageToken", newJString(pageToken))
  add(query_579943, "callback", newJString(callback))
  add(query_579943, "fields", newJString(fields))
  add(query_579943, "access_token", newJString(accessToken))
  add(query_579943, "upload_protocol", newJString(uploadProtocol))
  add(query_579943, "showDeleted", newJBool(showDeleted))
  result = call_579942.call(nil, query_579943, nil, nil, nil)

var cloudresourcemanagerFoldersList* = Call_CloudresourcemanagerFoldersList_579923(
    name: "cloudresourcemanagerFoldersList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders",
    validator: validate_CloudresourcemanagerFoldersList_579924, base: "/",
    url: url_CloudresourcemanagerFoldersList_579925, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersSearch_579964 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersSearch_579966(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudresourcemanagerFoldersSearch_579965(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search for folders that match specific filter criteria.
  ## Search provides an eventually consistent view of the folders a user has
  ## access to which meet the specified filter criteria.
  ## 
  ## This will only return folders on which the caller has the
  ## permission `resourcemanager.folders.get`.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579967 = query.getOrDefault("key")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "key", valid_579967
  var valid_579968 = query.getOrDefault("prettyPrint")
  valid_579968 = validateParameter(valid_579968, JBool, required = false,
                                 default = newJBool(true))
  if valid_579968 != nil:
    section.add "prettyPrint", valid_579968
  var valid_579969 = query.getOrDefault("oauth_token")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "oauth_token", valid_579969
  var valid_579970 = query.getOrDefault("$.xgafv")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = newJString("1"))
  if valid_579970 != nil:
    section.add "$.xgafv", valid_579970
  var valid_579971 = query.getOrDefault("alt")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = newJString("json"))
  if valid_579971 != nil:
    section.add "alt", valid_579971
  var valid_579972 = query.getOrDefault("uploadType")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "uploadType", valid_579972
  var valid_579973 = query.getOrDefault("quotaUser")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "quotaUser", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("fields")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "fields", valid_579975
  var valid_579976 = query.getOrDefault("access_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "access_token", valid_579976
  var valid_579977 = query.getOrDefault("upload_protocol")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "upload_protocol", valid_579977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579979: Call_CloudresourcemanagerFoldersSearch_579964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search for folders that match specific filter criteria.
  ## Search provides an eventually consistent view of the folders a user has
  ## access to which meet the specified filter criteria.
  ## 
  ## This will only return folders on which the caller has the
  ## permission `resourcemanager.folders.get`.
  ## 
  let valid = call_579979.validator(path, query, header, formData, body)
  let scheme = call_579979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579979.url(scheme.get, call_579979.host, call_579979.base,
                         call_579979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579979, url, valid)

proc call*(call_579980: Call_CloudresourcemanagerFoldersSearch_579964;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerFoldersSearch
  ## Search for folders that match specific filter criteria.
  ## Search provides an eventually consistent view of the folders a user has
  ## access to which meet the specified filter criteria.
  ## 
  ## This will only return folders on which the caller has the
  ## permission `resourcemanager.folders.get`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579981 = newJObject()
  var body_579982 = newJObject()
  add(query_579981, "key", newJString(key))
  add(query_579981, "prettyPrint", newJBool(prettyPrint))
  add(query_579981, "oauth_token", newJString(oauthToken))
  add(query_579981, "$.xgafv", newJString(Xgafv))
  add(query_579981, "alt", newJString(alt))
  add(query_579981, "uploadType", newJString(uploadType))
  add(query_579981, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579982 = body
  add(query_579981, "callback", newJString(callback))
  add(query_579981, "fields", newJString(fields))
  add(query_579981, "access_token", newJString(accessToken))
  add(query_579981, "upload_protocol", newJString(uploadProtocol))
  result = call_579980.call(nil, query_579981, nil, nil, body_579982)

var cloudresourcemanagerFoldersSearch* = Call_CloudresourcemanagerFoldersSearch_579964(
    name: "cloudresourcemanagerFoldersSearch", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders:search",
    validator: validate_CloudresourcemanagerFoldersSearch_579965, base: "/",
    url: url_CloudresourcemanagerFoldersSearch_579966, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersGet_579983 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersGet_579985(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersGet_579984(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a Folder identified by the supplied resource name.
  ## Valid Folder resource names have the format `folders/{folder_id}`
  ## (for example, `folders/1234`).
  ## The caller must have `resourcemanager.folders.get` permission on the
  ## identified folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the Folder to retrieve.
  ## Must be of the form `folders/{folder_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579986 = path.getOrDefault("name")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "name", valid_579986
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579987 = query.getOrDefault("key")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "key", valid_579987
  var valid_579988 = query.getOrDefault("prettyPrint")
  valid_579988 = validateParameter(valid_579988, JBool, required = false,
                                 default = newJBool(true))
  if valid_579988 != nil:
    section.add "prettyPrint", valid_579988
  var valid_579989 = query.getOrDefault("oauth_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "oauth_token", valid_579989
  var valid_579990 = query.getOrDefault("$.xgafv")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = newJString("1"))
  if valid_579990 != nil:
    section.add "$.xgafv", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("uploadType")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "uploadType", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("callback")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "callback", valid_579994
  var valid_579995 = query.getOrDefault("fields")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "fields", valid_579995
  var valid_579996 = query.getOrDefault("access_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "access_token", valid_579996
  var valid_579997 = query.getOrDefault("upload_protocol")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "upload_protocol", valid_579997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579998: Call_CloudresourcemanagerFoldersGet_579983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Folder identified by the supplied resource name.
  ## Valid Folder resource names have the format `folders/{folder_id}`
  ## (for example, `folders/1234`).
  ## The caller must have `resourcemanager.folders.get` permission on the
  ## identified folder.
  ## 
  let valid = call_579998.validator(path, query, header, formData, body)
  let scheme = call_579998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579998.url(scheme.get, call_579998.host, call_579998.base,
                         call_579998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579998, url, valid)

proc call*(call_579999: Call_CloudresourcemanagerFoldersGet_579983; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerFoldersGet
  ## Retrieves a Folder identified by the supplied resource name.
  ## Valid Folder resource names have the format `folders/{folder_id}`
  ## (for example, `folders/1234`).
  ## The caller must have `resourcemanager.folders.get` permission on the
  ## identified folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the Folder to retrieve.
  ## Must be of the form `folders/{folder_id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580000 = newJObject()
  var query_580001 = newJObject()
  add(query_580001, "key", newJString(key))
  add(query_580001, "prettyPrint", newJBool(prettyPrint))
  add(query_580001, "oauth_token", newJString(oauthToken))
  add(query_580001, "$.xgafv", newJString(Xgafv))
  add(query_580001, "alt", newJString(alt))
  add(query_580001, "uploadType", newJString(uploadType))
  add(query_580001, "quotaUser", newJString(quotaUser))
  add(path_580000, "name", newJString(name))
  add(query_580001, "callback", newJString(callback))
  add(query_580001, "fields", newJString(fields))
  add(query_580001, "access_token", newJString(accessToken))
  add(query_580001, "upload_protocol", newJString(uploadProtocol))
  result = call_579999.call(path_580000, query_580001, nil, nil, nil)

var cloudresourcemanagerFoldersGet* = Call_CloudresourcemanagerFoldersGet_579983(
    name: "cloudresourcemanagerFoldersGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersGet_579984, base: "/",
    url: url_CloudresourcemanagerFoldersGet_579985, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersPatch_580021 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersPatch_580023(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersPatch_580022(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Folder, changing its display_name.
  ## Changes to the folder display_name will be rejected if they violate either
  ## the display_name formatting rules or naming constraints described in
  ## the CreateFolder documentation.
  ## 
  ## The Folder's display name must start and end with a letter or digit,
  ## may contain letters, digits, spaces, hyphens and underscores and can be
  ## no longer than 30 characters. This is captured by the regular expression:
  ## [\p{L}\p{N}]([\p{L}\p{N}_- ]{0,28}[\p{L}\p{N}])?.
  ## The caller must have `resourcemanager.folders.update` permission on the
  ## identified folder.
  ## 
  ## If the update fails due to the unique name constraint then a
  ## PreconditionFailure explaining this violation will be returned
  ## in the Status.details field.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. The resource name of the Folder.
  ## Its format is `folders/{folder_id}`, for example: "folders/1234".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580024 = path.getOrDefault("name")
  valid_580024 = validateParameter(valid_580024, JString, required = true,
                                 default = nil)
  if valid_580024 != nil:
    section.add "name", valid_580024
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Required. Fields to be updated.
  ## Only the `display_name` can be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580025 = query.getOrDefault("key")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "key", valid_580025
  var valid_580026 = query.getOrDefault("prettyPrint")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(true))
  if valid_580026 != nil:
    section.add "prettyPrint", valid_580026
  var valid_580027 = query.getOrDefault("oauth_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "oauth_token", valid_580027
  var valid_580028 = query.getOrDefault("$.xgafv")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = newJString("1"))
  if valid_580028 != nil:
    section.add "$.xgafv", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("uploadType")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "uploadType", valid_580030
  var valid_580031 = query.getOrDefault("quotaUser")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "quotaUser", valid_580031
  var valid_580032 = query.getOrDefault("updateMask")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "updateMask", valid_580032
  var valid_580033 = query.getOrDefault("callback")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "callback", valid_580033
  var valid_580034 = query.getOrDefault("fields")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "fields", valid_580034
  var valid_580035 = query.getOrDefault("access_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "access_token", valid_580035
  var valid_580036 = query.getOrDefault("upload_protocol")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "upload_protocol", valid_580036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580038: Call_CloudresourcemanagerFoldersPatch_580021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Folder, changing its display_name.
  ## Changes to the folder display_name will be rejected if they violate either
  ## the display_name formatting rules or naming constraints described in
  ## the CreateFolder documentation.
  ## 
  ## The Folder's display name must start and end with a letter or digit,
  ## may contain letters, digits, spaces, hyphens and underscores and can be
  ## no longer than 30 characters. This is captured by the regular expression:
  ## [\p{L}\p{N}]([\p{L}\p{N}_- ]{0,28}[\p{L}\p{N}])?.
  ## The caller must have `resourcemanager.folders.update` permission on the
  ## identified folder.
  ## 
  ## If the update fails due to the unique name constraint then a
  ## PreconditionFailure explaining this violation will be returned
  ## in the Status.details field.
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_CloudresourcemanagerFoldersPatch_580021; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerFoldersPatch
  ## Updates a Folder, changing its display_name.
  ## Changes to the folder display_name will be rejected if they violate either
  ## the display_name formatting rules or naming constraints described in
  ## the CreateFolder documentation.
  ## 
  ## The Folder's display name must start and end with a letter or digit,
  ## may contain letters, digits, spaces, hyphens and underscores and can be
  ## no longer than 30 characters. This is captured by the regular expression:
  ## [\p{L}\p{N}]([\p{L}\p{N}_- ]{0,28}[\p{L}\p{N}])?.
  ## The caller must have `resourcemanager.folders.update` permission on the
  ## identified folder.
  ## 
  ## If the update fails due to the unique name constraint then a
  ## PreconditionFailure explaining this violation will be returned
  ## in the Status.details field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The resource name of the Folder.
  ## Its format is `folders/{folder_id}`, for example: "folders/1234".
  ##   updateMask: string
  ##             : Required. Fields to be updated.
  ## Only the `display_name` can be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580040 = newJObject()
  var query_580041 = newJObject()
  var body_580042 = newJObject()
  add(query_580041, "key", newJString(key))
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "uploadType", newJString(uploadType))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(path_580040, "name", newJString(name))
  add(query_580041, "updateMask", newJString(updateMask))
  if body != nil:
    body_580042 = body
  add(query_580041, "callback", newJString(callback))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  result = call_580039.call(path_580040, query_580041, nil, nil, body_580042)

var cloudresourcemanagerFoldersPatch* = Call_CloudresourcemanagerFoldersPatch_580021(
    name: "cloudresourcemanagerFoldersPatch", meth: HttpMethod.HttpPatch,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersPatch_580022, base: "/",
    url: url_CloudresourcemanagerFoldersPatch_580023, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersDelete_580002 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersDelete_580004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersDelete_580003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests deletion of a Folder. The Folder is moved into the
  ## DELETE_REQUESTED state
  ## immediately, and is deleted approximately 30 days later. This method may
  ## only be called on an empty Folder in the
  ## ACTIVE state, where a Folder is empty if
  ## it doesn't contain any Folders or Projects in the
  ## ACTIVE state.
  ## The caller must have `resourcemanager.folders.delete` permission on the
  ## identified folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. the resource name of the Folder to be deleted.
  ## Must be of the form `folders/{folder_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580005 = path.getOrDefault("name")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "name", valid_580005
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580006 = query.getOrDefault("key")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "key", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("$.xgafv")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("1"))
  if valid_580009 != nil:
    section.add "$.xgafv", valid_580009
  var valid_580010 = query.getOrDefault("alt")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("json"))
  if valid_580010 != nil:
    section.add "alt", valid_580010
  var valid_580011 = query.getOrDefault("uploadType")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "uploadType", valid_580011
  var valid_580012 = query.getOrDefault("quotaUser")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "quotaUser", valid_580012
  var valid_580013 = query.getOrDefault("callback")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "callback", valid_580013
  var valid_580014 = query.getOrDefault("fields")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "fields", valid_580014
  var valid_580015 = query.getOrDefault("access_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "access_token", valid_580015
  var valid_580016 = query.getOrDefault("upload_protocol")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "upload_protocol", valid_580016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580017: Call_CloudresourcemanagerFoldersDelete_580002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests deletion of a Folder. The Folder is moved into the
  ## DELETE_REQUESTED state
  ## immediately, and is deleted approximately 30 days later. This method may
  ## only be called on an empty Folder in the
  ## ACTIVE state, where a Folder is empty if
  ## it doesn't contain any Folders or Projects in the
  ## ACTIVE state.
  ## The caller must have `resourcemanager.folders.delete` permission on the
  ## identified folder.
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_CloudresourcemanagerFoldersDelete_580002;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerFoldersDelete
  ## Requests deletion of a Folder. The Folder is moved into the
  ## DELETE_REQUESTED state
  ## immediately, and is deleted approximately 30 days later. This method may
  ## only be called on an empty Folder in the
  ## ACTIVE state, where a Folder is empty if
  ## it doesn't contain any Folders or Projects in the
  ## ACTIVE state.
  ## The caller must have `resourcemanager.folders.delete` permission on the
  ## identified folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. the resource name of the Folder to be deleted.
  ## Must be of the form `folders/{folder_id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580019 = newJObject()
  var query_580020 = newJObject()
  add(query_580020, "key", newJString(key))
  add(query_580020, "prettyPrint", newJBool(prettyPrint))
  add(query_580020, "oauth_token", newJString(oauthToken))
  add(query_580020, "$.xgafv", newJString(Xgafv))
  add(query_580020, "alt", newJString(alt))
  add(query_580020, "uploadType", newJString(uploadType))
  add(query_580020, "quotaUser", newJString(quotaUser))
  add(path_580019, "name", newJString(name))
  add(query_580020, "callback", newJString(callback))
  add(query_580020, "fields", newJString(fields))
  add(query_580020, "access_token", newJString(accessToken))
  add(query_580020, "upload_protocol", newJString(uploadProtocol))
  result = call_580018.call(path_580019, query_580020, nil, nil, nil)

var cloudresourcemanagerFoldersDelete* = Call_CloudresourcemanagerFoldersDelete_580002(
    name: "cloudresourcemanagerFoldersDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersDelete_580003, base: "/",
    url: url_CloudresourcemanagerFoldersDelete_580004, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersMove_580043 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersMove_580045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":move")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersMove_580044(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Moves a Folder under a new resource parent.
  ## Returns an Operation which can be used to track the progress of the
  ## folder move workflow.
  ## Upon success the Operation.response field will be populated with the
  ## moved Folder.
  ## Upon failure, a FolderOperationError categorizing the failure cause will
  ## be returned - if the failure occurs synchronously then the
  ## FolderOperationError will be returned via the Status.details field
  ## and if it occurs asynchronously then the FolderOperation will be returned
  ## via the Operation.error field.
  ## In addition, the Operation.metadata field will be populated with a
  ## FolderOperation message as an aid to stateless clients.
  ## Folder moves will be rejected if they violate either the naming, height
  ## or fanout constraints described in the
  ## CreateFolder documentation.
  ## The caller must have `resourcemanager.folders.move` permission on the
  ## folder's current and proposed new parent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the Folder to move.
  ## Must be of the form folders/{folder_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580046 = path.getOrDefault("name")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "name", valid_580046
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("prettyPrint")
  valid_580048 = validateParameter(valid_580048, JBool, required = false,
                                 default = newJBool(true))
  if valid_580048 != nil:
    section.add "prettyPrint", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("$.xgafv")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("1"))
  if valid_580050 != nil:
    section.add "$.xgafv", valid_580050
  var valid_580051 = query.getOrDefault("alt")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("json"))
  if valid_580051 != nil:
    section.add "alt", valid_580051
  var valid_580052 = query.getOrDefault("uploadType")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "uploadType", valid_580052
  var valid_580053 = query.getOrDefault("quotaUser")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "quotaUser", valid_580053
  var valid_580054 = query.getOrDefault("callback")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "callback", valid_580054
  var valid_580055 = query.getOrDefault("fields")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "fields", valid_580055
  var valid_580056 = query.getOrDefault("access_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "access_token", valid_580056
  var valid_580057 = query.getOrDefault("upload_protocol")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "upload_protocol", valid_580057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580059: Call_CloudresourcemanagerFoldersMove_580043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves a Folder under a new resource parent.
  ## Returns an Operation which can be used to track the progress of the
  ## folder move workflow.
  ## Upon success the Operation.response field will be populated with the
  ## moved Folder.
  ## Upon failure, a FolderOperationError categorizing the failure cause will
  ## be returned - if the failure occurs synchronously then the
  ## FolderOperationError will be returned via the Status.details field
  ## and if it occurs asynchronously then the FolderOperation will be returned
  ## via the Operation.error field.
  ## In addition, the Operation.metadata field will be populated with a
  ## FolderOperation message as an aid to stateless clients.
  ## Folder moves will be rejected if they violate either the naming, height
  ## or fanout constraints described in the
  ## CreateFolder documentation.
  ## The caller must have `resourcemanager.folders.move` permission on the
  ## folder's current and proposed new parent.
  ## 
  let valid = call_580059.validator(path, query, header, formData, body)
  let scheme = call_580059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580059.url(scheme.get, call_580059.host, call_580059.base,
                         call_580059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580059, url, valid)

proc call*(call_580060: Call_CloudresourcemanagerFoldersMove_580043; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerFoldersMove
  ## Moves a Folder under a new resource parent.
  ## Returns an Operation which can be used to track the progress of the
  ## folder move workflow.
  ## Upon success the Operation.response field will be populated with the
  ## moved Folder.
  ## Upon failure, a FolderOperationError categorizing the failure cause will
  ## be returned - if the failure occurs synchronously then the
  ## FolderOperationError will be returned via the Status.details field
  ## and if it occurs asynchronously then the FolderOperation will be returned
  ## via the Operation.error field.
  ## In addition, the Operation.metadata field will be populated with a
  ## FolderOperation message as an aid to stateless clients.
  ## Folder moves will be rejected if they violate either the naming, height
  ## or fanout constraints described in the
  ## CreateFolder documentation.
  ## The caller must have `resourcemanager.folders.move` permission on the
  ## folder's current and proposed new parent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the Folder to move.
  ## Must be of the form folders/{folder_id}
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580061 = newJObject()
  var query_580062 = newJObject()
  var body_580063 = newJObject()
  add(query_580062, "key", newJString(key))
  add(query_580062, "prettyPrint", newJBool(prettyPrint))
  add(query_580062, "oauth_token", newJString(oauthToken))
  add(query_580062, "$.xgafv", newJString(Xgafv))
  add(query_580062, "alt", newJString(alt))
  add(query_580062, "uploadType", newJString(uploadType))
  add(query_580062, "quotaUser", newJString(quotaUser))
  add(path_580061, "name", newJString(name))
  if body != nil:
    body_580063 = body
  add(query_580062, "callback", newJString(callback))
  add(query_580062, "fields", newJString(fields))
  add(query_580062, "access_token", newJString(accessToken))
  add(query_580062, "upload_protocol", newJString(uploadProtocol))
  result = call_580060.call(path_580061, query_580062, nil, nil, body_580063)

var cloudresourcemanagerFoldersMove* = Call_CloudresourcemanagerFoldersMove_580043(
    name: "cloudresourcemanagerFoldersMove", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}:move",
    validator: validate_CloudresourcemanagerFoldersMove_580044, base: "/",
    url: url_CloudresourcemanagerFoldersMove_580045, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersUndelete_580064 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersUndelete_580066(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersUndelete_580065(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the deletion request for a Folder. This method may only be
  ## called on a Folder in the
  ## DELETE_REQUESTED state.
  ## In order to succeed, the Folder's parent must be in the
  ## ACTIVE state.
  ## In addition, reintroducing the folder into the tree must not violate
  ## folder naming, height and fanout constraints described in the
  ## CreateFolder documentation.
  ## The caller must have `resourcemanager.folders.undelete` permission on the
  ## identified folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the Folder to undelete.
  ## Must be of the form `folders/{folder_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580067 = path.getOrDefault("name")
  valid_580067 = validateParameter(valid_580067, JString, required = true,
                                 default = nil)
  if valid_580067 != nil:
    section.add "name", valid_580067
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580068 = query.getOrDefault("key")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "key", valid_580068
  var valid_580069 = query.getOrDefault("prettyPrint")
  valid_580069 = validateParameter(valid_580069, JBool, required = false,
                                 default = newJBool(true))
  if valid_580069 != nil:
    section.add "prettyPrint", valid_580069
  var valid_580070 = query.getOrDefault("oauth_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "oauth_token", valid_580070
  var valid_580071 = query.getOrDefault("$.xgafv")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("1"))
  if valid_580071 != nil:
    section.add "$.xgafv", valid_580071
  var valid_580072 = query.getOrDefault("alt")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("json"))
  if valid_580072 != nil:
    section.add "alt", valid_580072
  var valid_580073 = query.getOrDefault("uploadType")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "uploadType", valid_580073
  var valid_580074 = query.getOrDefault("quotaUser")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "quotaUser", valid_580074
  var valid_580075 = query.getOrDefault("callback")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "callback", valid_580075
  var valid_580076 = query.getOrDefault("fields")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "fields", valid_580076
  var valid_580077 = query.getOrDefault("access_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "access_token", valid_580077
  var valid_580078 = query.getOrDefault("upload_protocol")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "upload_protocol", valid_580078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580080: Call_CloudresourcemanagerFoldersUndelete_580064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the deletion request for a Folder. This method may only be
  ## called on a Folder in the
  ## DELETE_REQUESTED state.
  ## In order to succeed, the Folder's parent must be in the
  ## ACTIVE state.
  ## In addition, reintroducing the folder into the tree must not violate
  ## folder naming, height and fanout constraints described in the
  ## CreateFolder documentation.
  ## The caller must have `resourcemanager.folders.undelete` permission on the
  ## identified folder.
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_CloudresourcemanagerFoldersUndelete_580064;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerFoldersUndelete
  ## Cancels the deletion request for a Folder. This method may only be
  ## called on a Folder in the
  ## DELETE_REQUESTED state.
  ## In order to succeed, the Folder's parent must be in the
  ## ACTIVE state.
  ## In addition, reintroducing the folder into the tree must not violate
  ## folder naming, height and fanout constraints described in the
  ## CreateFolder documentation.
  ## The caller must have `resourcemanager.folders.undelete` permission on the
  ## identified folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the Folder to undelete.
  ## Must be of the form `folders/{folder_id}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  var body_580084 = newJObject()
  add(query_580083, "key", newJString(key))
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "$.xgafv", newJString(Xgafv))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "uploadType", newJString(uploadType))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(path_580082, "name", newJString(name))
  if body != nil:
    body_580084 = body
  add(query_580083, "callback", newJString(callback))
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "access_token", newJString(accessToken))
  add(query_580083, "upload_protocol", newJString(uploadProtocol))
  result = call_580081.call(path_580082, query_580083, nil, nil, body_580084)

var cloudresourcemanagerFoldersUndelete* = Call_CloudresourcemanagerFoldersUndelete_580064(
    name: "cloudresourcemanagerFoldersUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}:undelete",
    validator: validate_CloudresourcemanagerFoldersUndelete_580065, base: "/",
    url: url_CloudresourcemanagerFoldersUndelete_580066, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersGetIamPolicy_580085 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersGetIamPolicy_580087(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersGetIamPolicy_580086(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a Folder. The returned policy may be
  ## empty if no such policy or resource exists. The `resource` field should
  ## be the Folder's resource name, e.g. "folders/1234".
  ## The caller must have `resourcemanager.folders.getIamPolicy` permission
  ## on the identified folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580088 = path.getOrDefault("resource")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "resource", valid_580088
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("prettyPrint")
  valid_580090 = validateParameter(valid_580090, JBool, required = false,
                                 default = newJBool(true))
  if valid_580090 != nil:
    section.add "prettyPrint", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("$.xgafv")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("1"))
  if valid_580092 != nil:
    section.add "$.xgafv", valid_580092
  var valid_580093 = query.getOrDefault("alt")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("json"))
  if valid_580093 != nil:
    section.add "alt", valid_580093
  var valid_580094 = query.getOrDefault("uploadType")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "uploadType", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("callback")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "callback", valid_580096
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
  var valid_580098 = query.getOrDefault("access_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "access_token", valid_580098
  var valid_580099 = query.getOrDefault("upload_protocol")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "upload_protocol", valid_580099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580101: Call_CloudresourcemanagerFoldersGetIamPolicy_580085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a Folder. The returned policy may be
  ## empty if no such policy or resource exists. The `resource` field should
  ## be the Folder's resource name, e.g. "folders/1234".
  ## The caller must have `resourcemanager.folders.getIamPolicy` permission
  ## on the identified folder.
  ## 
  let valid = call_580101.validator(path, query, header, formData, body)
  let scheme = call_580101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580101.url(scheme.get, call_580101.host, call_580101.base,
                         call_580101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580101, url, valid)

proc call*(call_580102: Call_CloudresourcemanagerFoldersGetIamPolicy_580085;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerFoldersGetIamPolicy
  ## Gets the access control policy for a Folder. The returned policy may be
  ## empty if no such policy or resource exists. The `resource` field should
  ## be the Folder's resource name, e.g. "folders/1234".
  ## The caller must have `resourcemanager.folders.getIamPolicy` permission
  ## on the identified folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580103 = newJObject()
  var query_580104 = newJObject()
  var body_580105 = newJObject()
  add(query_580104, "key", newJString(key))
  add(query_580104, "prettyPrint", newJBool(prettyPrint))
  add(query_580104, "oauth_token", newJString(oauthToken))
  add(query_580104, "$.xgafv", newJString(Xgafv))
  add(query_580104, "alt", newJString(alt))
  add(query_580104, "uploadType", newJString(uploadType))
  add(query_580104, "quotaUser", newJString(quotaUser))
  add(path_580103, "resource", newJString(resource))
  if body != nil:
    body_580105 = body
  add(query_580104, "callback", newJString(callback))
  add(query_580104, "fields", newJString(fields))
  add(query_580104, "access_token", newJString(accessToken))
  add(query_580104, "upload_protocol", newJString(uploadProtocol))
  result = call_580102.call(path_580103, query_580104, nil, nil, body_580105)

var cloudresourcemanagerFoldersGetIamPolicy* = Call_CloudresourcemanagerFoldersGetIamPolicy_580085(
    name: "cloudresourcemanagerFoldersGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerFoldersGetIamPolicy_580086, base: "/",
    url: url_CloudresourcemanagerFoldersGetIamPolicy_580087,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersSetIamPolicy_580106 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersSetIamPolicy_580108(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersSetIamPolicy_580107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on a Folder, replacing any existing policy.
  ## The `resource` field should be the Folder's resource name, e.g.
  ## "folders/1234".
  ## The caller must have `resourcemanager.folders.setIamPolicy` permission
  ## on the identified folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580109 = path.getOrDefault("resource")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "resource", valid_580109
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580110 = query.getOrDefault("key")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "key", valid_580110
  var valid_580111 = query.getOrDefault("prettyPrint")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "prettyPrint", valid_580111
  var valid_580112 = query.getOrDefault("oauth_token")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "oauth_token", valid_580112
  var valid_580113 = query.getOrDefault("$.xgafv")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("1"))
  if valid_580113 != nil:
    section.add "$.xgafv", valid_580113
  var valid_580114 = query.getOrDefault("alt")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("json"))
  if valid_580114 != nil:
    section.add "alt", valid_580114
  var valid_580115 = query.getOrDefault("uploadType")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "uploadType", valid_580115
  var valid_580116 = query.getOrDefault("quotaUser")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "quotaUser", valid_580116
  var valid_580117 = query.getOrDefault("callback")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "callback", valid_580117
  var valid_580118 = query.getOrDefault("fields")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "fields", valid_580118
  var valid_580119 = query.getOrDefault("access_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "access_token", valid_580119
  var valid_580120 = query.getOrDefault("upload_protocol")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "upload_protocol", valid_580120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580122: Call_CloudresourcemanagerFoldersSetIamPolicy_580106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on a Folder, replacing any existing policy.
  ## The `resource` field should be the Folder's resource name, e.g.
  ## "folders/1234".
  ## The caller must have `resourcemanager.folders.setIamPolicy` permission
  ## on the identified folder.
  ## 
  let valid = call_580122.validator(path, query, header, formData, body)
  let scheme = call_580122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580122.url(scheme.get, call_580122.host, call_580122.base,
                         call_580122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580122, url, valid)

proc call*(call_580123: Call_CloudresourcemanagerFoldersSetIamPolicy_580106;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerFoldersSetIamPolicy
  ## Sets the access control policy on a Folder, replacing any existing policy.
  ## The `resource` field should be the Folder's resource name, e.g.
  ## "folders/1234".
  ## The caller must have `resourcemanager.folders.setIamPolicy` permission
  ## on the identified folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580124 = newJObject()
  var query_580125 = newJObject()
  var body_580126 = newJObject()
  add(query_580125, "key", newJString(key))
  add(query_580125, "prettyPrint", newJBool(prettyPrint))
  add(query_580125, "oauth_token", newJString(oauthToken))
  add(query_580125, "$.xgafv", newJString(Xgafv))
  add(query_580125, "alt", newJString(alt))
  add(query_580125, "uploadType", newJString(uploadType))
  add(query_580125, "quotaUser", newJString(quotaUser))
  add(path_580124, "resource", newJString(resource))
  if body != nil:
    body_580126 = body
  add(query_580125, "callback", newJString(callback))
  add(query_580125, "fields", newJString(fields))
  add(query_580125, "access_token", newJString(accessToken))
  add(query_580125, "upload_protocol", newJString(uploadProtocol))
  result = call_580123.call(path_580124, query_580125, nil, nil, body_580126)

var cloudresourcemanagerFoldersSetIamPolicy* = Call_CloudresourcemanagerFoldersSetIamPolicy_580106(
    name: "cloudresourcemanagerFoldersSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerFoldersSetIamPolicy_580107, base: "/",
    url: url_CloudresourcemanagerFoldersSetIamPolicy_580108,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersTestIamPermissions_580127 = ref object of OpenApiRestCall_579364
proc url_CloudresourcemanagerFoldersTestIamPermissions_580129(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersTestIamPermissions_580128(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Folder.
  ## The `resource` field should be the Folder's resource name,
  ## e.g. "folders/1234".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580130 = path.getOrDefault("resource")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "resource", valid_580130
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580131 = query.getOrDefault("key")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "key", valid_580131
  var valid_580132 = query.getOrDefault("prettyPrint")
  valid_580132 = validateParameter(valid_580132, JBool, required = false,
                                 default = newJBool(true))
  if valid_580132 != nil:
    section.add "prettyPrint", valid_580132
  var valid_580133 = query.getOrDefault("oauth_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "oauth_token", valid_580133
  var valid_580134 = query.getOrDefault("$.xgafv")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("1"))
  if valid_580134 != nil:
    section.add "$.xgafv", valid_580134
  var valid_580135 = query.getOrDefault("alt")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = newJString("json"))
  if valid_580135 != nil:
    section.add "alt", valid_580135
  var valid_580136 = query.getOrDefault("uploadType")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "uploadType", valid_580136
  var valid_580137 = query.getOrDefault("quotaUser")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "quotaUser", valid_580137
  var valid_580138 = query.getOrDefault("callback")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "callback", valid_580138
  var valid_580139 = query.getOrDefault("fields")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "fields", valid_580139
  var valid_580140 = query.getOrDefault("access_token")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "access_token", valid_580140
  var valid_580141 = query.getOrDefault("upload_protocol")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "upload_protocol", valid_580141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580143: Call_CloudresourcemanagerFoldersTestIamPermissions_580127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Folder.
  ## The `resource` field should be the Folder's resource name,
  ## e.g. "folders/1234".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_580143.validator(path, query, header, formData, body)
  let scheme = call_580143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580143.url(scheme.get, call_580143.host, call_580143.base,
                         call_580143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580143, url, valid)

proc call*(call_580144: Call_CloudresourcemanagerFoldersTestIamPermissions_580127;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerFoldersTestIamPermissions
  ## Returns permissions that a caller has on the specified Folder.
  ## The `resource` field should be the Folder's resource name,
  ## e.g. "folders/1234".
  ## 
  ## There are no permissions required for making this API call.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580145 = newJObject()
  var query_580146 = newJObject()
  var body_580147 = newJObject()
  add(query_580146, "key", newJString(key))
  add(query_580146, "prettyPrint", newJBool(prettyPrint))
  add(query_580146, "oauth_token", newJString(oauthToken))
  add(query_580146, "$.xgafv", newJString(Xgafv))
  add(query_580146, "alt", newJString(alt))
  add(query_580146, "uploadType", newJString(uploadType))
  add(query_580146, "quotaUser", newJString(quotaUser))
  add(path_580145, "resource", newJString(resource))
  if body != nil:
    body_580147 = body
  add(query_580146, "callback", newJString(callback))
  add(query_580146, "fields", newJString(fields))
  add(query_580146, "access_token", newJString(accessToken))
  add(query_580146, "upload_protocol", newJString(uploadProtocol))
  result = call_580144.call(path_580145, query_580146, nil, nil, body_580147)

var cloudresourcemanagerFoldersTestIamPermissions* = Call_CloudresourcemanagerFoldersTestIamPermissions_580127(
    name: "cloudresourcemanagerFoldersTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerFoldersTestIamPermissions_580128,
    base: "/", url: url_CloudresourcemanagerFoldersTestIamPermissions_580129,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
