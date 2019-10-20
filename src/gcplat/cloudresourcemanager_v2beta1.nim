
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  Call_CloudresourcemanagerOperationsGet_578610 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerOperationsGet_578612(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOperationsGet_578611(path: JsonNode;
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
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_CloudresourcemanagerOperationsGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_CloudresourcemanagerOperationsGet_578610;
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
  var path_578857 = newJObject()
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(query_578859, "$.xgafv", newJString(Xgafv))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "uploadType", newJString(uploadType))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(path_578857, "name", newJString(name))
  add(query_578859, "callback", newJString(callback))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "access_token", newJString(accessToken))
  add(query_578859, "upload_protocol", newJString(uploadProtocol))
  result = call_578856.call(path_578857, query_578859, nil, nil, nil)

var cloudresourcemanagerOperationsGet* = Call_CloudresourcemanagerOperationsGet_578610(
    name: "cloudresourcemanagerOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerOperationsGet_578611, base: "/",
    url: url_CloudresourcemanagerOperationsGet_578612, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersCreate_578919 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersCreate_578921(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersCreate_578920(path: JsonNode;
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
  ##         : The resource name of the new Folder's parent.
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
  var valid_578922 = query.getOrDefault("key")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "key", valid_578922
  var valid_578923 = query.getOrDefault("prettyPrint")
  valid_578923 = validateParameter(valid_578923, JBool, required = false,
                                 default = newJBool(true))
  if valid_578923 != nil:
    section.add "prettyPrint", valid_578923
  var valid_578924 = query.getOrDefault("oauth_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "oauth_token", valid_578924
  var valid_578925 = query.getOrDefault("$.xgafv")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("1"))
  if valid_578925 != nil:
    section.add "$.xgafv", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("uploadType")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "uploadType", valid_578927
  var valid_578928 = query.getOrDefault("parent")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "parent", valid_578928
  var valid_578929 = query.getOrDefault("quotaUser")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "quotaUser", valid_578929
  var valid_578930 = query.getOrDefault("callback")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "callback", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("access_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "access_token", valid_578932
  var valid_578933 = query.getOrDefault("upload_protocol")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "upload_protocol", valid_578933
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

proc call*(call_578935: Call_CloudresourcemanagerFoldersCreate_578919;
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
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_CloudresourcemanagerFoldersCreate_578919;
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
  ##         : The resource name of the new Folder's parent.
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
  var query_578937 = newJObject()
  var body_578938 = newJObject()
  add(query_578937, "key", newJString(key))
  add(query_578937, "prettyPrint", newJBool(prettyPrint))
  add(query_578937, "oauth_token", newJString(oauthToken))
  add(query_578937, "$.xgafv", newJString(Xgafv))
  add(query_578937, "alt", newJString(alt))
  add(query_578937, "uploadType", newJString(uploadType))
  add(query_578937, "parent", newJString(parent))
  add(query_578937, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578938 = body
  add(query_578937, "callback", newJString(callback))
  add(query_578937, "fields", newJString(fields))
  add(query_578937, "access_token", newJString(accessToken))
  add(query_578937, "upload_protocol", newJString(uploadProtocol))
  result = call_578936.call(nil, query_578937, nil, nil, body_578938)

var cloudresourcemanagerFoldersCreate* = Call_CloudresourcemanagerFoldersCreate_578919(
    name: "cloudresourcemanagerFoldersCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders",
    validator: validate_CloudresourcemanagerFoldersCreate_578920, base: "/",
    url: url_CloudresourcemanagerFoldersCreate_578921, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersList_578898 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersList_578900(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersList_578899(path: JsonNode;
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
  ##           : The maximum number of Folders to return in the response.
  ## This field is optional.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The resource name of the Organization or Folder whose Folders are
  ## being listed.
  ## Must be of the form `folders/{folder_id}` or `organizations/{org_id}`.
  ## Access to this method is controlled by checking the
  ## `resourcemanager.folders.list` permission on the `parent`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to `ListFolders`
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   showDeleted: JBool
  ##              : Controls whether Folders in the
  ## DELETE_REQUESTED
  ## state should be returned. Defaults to false. This field is optional.
  section = newJObject()
  var valid_578901 = query.getOrDefault("key")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "key", valid_578901
  var valid_578902 = query.getOrDefault("prettyPrint")
  valid_578902 = validateParameter(valid_578902, JBool, required = false,
                                 default = newJBool(true))
  if valid_578902 != nil:
    section.add "prettyPrint", valid_578902
  var valid_578903 = query.getOrDefault("oauth_token")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "oauth_token", valid_578903
  var valid_578904 = query.getOrDefault("$.xgafv")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = newJString("1"))
  if valid_578904 != nil:
    section.add "$.xgafv", valid_578904
  var valid_578905 = query.getOrDefault("pageSize")
  valid_578905 = validateParameter(valid_578905, JInt, required = false, default = nil)
  if valid_578905 != nil:
    section.add "pageSize", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("parent")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "parent", valid_578908
  var valid_578909 = query.getOrDefault("quotaUser")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "quotaUser", valid_578909
  var valid_578910 = query.getOrDefault("pageToken")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "pageToken", valid_578910
  var valid_578911 = query.getOrDefault("callback")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "callback", valid_578911
  var valid_578912 = query.getOrDefault("fields")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "fields", valid_578912
  var valid_578913 = query.getOrDefault("access_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "access_token", valid_578913
  var valid_578914 = query.getOrDefault("upload_protocol")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "upload_protocol", valid_578914
  var valid_578915 = query.getOrDefault("showDeleted")
  valid_578915 = validateParameter(valid_578915, JBool, required = false, default = nil)
  if valid_578915 != nil:
    section.add "showDeleted", valid_578915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578916: Call_CloudresourcemanagerFoldersList_578898;
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
  let valid = call_578916.validator(path, query, header, formData, body)
  let scheme = call_578916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578916.url(scheme.get, call_578916.host, call_578916.base,
                         call_578916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578916, url, valid)

proc call*(call_578917: Call_CloudresourcemanagerFoldersList_578898;
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
  ##           : The maximum number of Folders to return in the response.
  ## This field is optional.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The resource name of the Organization or Folder whose Folders are
  ## being listed.
  ## Must be of the form `folders/{folder_id}` or `organizations/{org_id}`.
  ## Access to this method is controlled by checking the
  ## `resourcemanager.folders.list` permission on the `parent`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to `ListFolders`
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   showDeleted: bool
  ##              : Controls whether Folders in the
  ## DELETE_REQUESTED
  ## state should be returned. Defaults to false. This field is optional.
  var query_578918 = newJObject()
  add(query_578918, "key", newJString(key))
  add(query_578918, "prettyPrint", newJBool(prettyPrint))
  add(query_578918, "oauth_token", newJString(oauthToken))
  add(query_578918, "$.xgafv", newJString(Xgafv))
  add(query_578918, "pageSize", newJInt(pageSize))
  add(query_578918, "alt", newJString(alt))
  add(query_578918, "uploadType", newJString(uploadType))
  add(query_578918, "parent", newJString(parent))
  add(query_578918, "quotaUser", newJString(quotaUser))
  add(query_578918, "pageToken", newJString(pageToken))
  add(query_578918, "callback", newJString(callback))
  add(query_578918, "fields", newJString(fields))
  add(query_578918, "access_token", newJString(accessToken))
  add(query_578918, "upload_protocol", newJString(uploadProtocol))
  add(query_578918, "showDeleted", newJBool(showDeleted))
  result = call_578917.call(nil, query_578918, nil, nil, nil)

var cloudresourcemanagerFoldersList* = Call_CloudresourcemanagerFoldersList_578898(
    name: "cloudresourcemanagerFoldersList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders",
    validator: validate_CloudresourcemanagerFoldersList_578899, base: "/",
    url: url_CloudresourcemanagerFoldersList_578900, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersSearch_578939 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersSearch_578941(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersSearch_578940(path: JsonNode;
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
  var valid_578942 = query.getOrDefault("key")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "key", valid_578942
  var valid_578943 = query.getOrDefault("prettyPrint")
  valid_578943 = validateParameter(valid_578943, JBool, required = false,
                                 default = newJBool(true))
  if valid_578943 != nil:
    section.add "prettyPrint", valid_578943
  var valid_578944 = query.getOrDefault("oauth_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "oauth_token", valid_578944
  var valid_578945 = query.getOrDefault("$.xgafv")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("1"))
  if valid_578945 != nil:
    section.add "$.xgafv", valid_578945
  var valid_578946 = query.getOrDefault("alt")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("json"))
  if valid_578946 != nil:
    section.add "alt", valid_578946
  var valid_578947 = query.getOrDefault("uploadType")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "uploadType", valid_578947
  var valid_578948 = query.getOrDefault("quotaUser")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "quotaUser", valid_578948
  var valid_578949 = query.getOrDefault("callback")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "callback", valid_578949
  var valid_578950 = query.getOrDefault("fields")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "fields", valid_578950
  var valid_578951 = query.getOrDefault("access_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "access_token", valid_578951
  var valid_578952 = query.getOrDefault("upload_protocol")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "upload_protocol", valid_578952
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

proc call*(call_578954: Call_CloudresourcemanagerFoldersSearch_578939;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search for folders that match specific filter criteria.
  ## Search provides an eventually consistent view of the folders a user has
  ## access to which meet the specified filter criteria.
  ## 
  ## This will only return folders on which the caller has the
  ## permission `resourcemanager.folders.get`.
  ## 
  let valid = call_578954.validator(path, query, header, formData, body)
  let scheme = call_578954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578954.url(scheme.get, call_578954.host, call_578954.base,
                         call_578954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578954, url, valid)

proc call*(call_578955: Call_CloudresourcemanagerFoldersSearch_578939;
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
  var query_578956 = newJObject()
  var body_578957 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(query_578956, "$.xgafv", newJString(Xgafv))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "uploadType", newJString(uploadType))
  add(query_578956, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578957 = body
  add(query_578956, "callback", newJString(callback))
  add(query_578956, "fields", newJString(fields))
  add(query_578956, "access_token", newJString(accessToken))
  add(query_578956, "upload_protocol", newJString(uploadProtocol))
  result = call_578955.call(nil, query_578956, nil, nil, body_578957)

var cloudresourcemanagerFoldersSearch* = Call_CloudresourcemanagerFoldersSearch_578939(
    name: "cloudresourcemanagerFoldersSearch", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders:search",
    validator: validate_CloudresourcemanagerFoldersSearch_578940, base: "/",
    url: url_CloudresourcemanagerFoldersSearch_578941, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersGet_578958 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersGet_578960(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersGet_578959(path: JsonNode;
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
  ##       : The resource name of the Folder to retrieve.
  ## Must be of the form `folders/{folder_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578961 = path.getOrDefault("name")
  valid_578961 = validateParameter(valid_578961, JString, required = true,
                                 default = nil)
  if valid_578961 != nil:
    section.add "name", valid_578961
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
  var valid_578962 = query.getOrDefault("key")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "key", valid_578962
  var valid_578963 = query.getOrDefault("prettyPrint")
  valid_578963 = validateParameter(valid_578963, JBool, required = false,
                                 default = newJBool(true))
  if valid_578963 != nil:
    section.add "prettyPrint", valid_578963
  var valid_578964 = query.getOrDefault("oauth_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "oauth_token", valid_578964
  var valid_578965 = query.getOrDefault("$.xgafv")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("1"))
  if valid_578965 != nil:
    section.add "$.xgafv", valid_578965
  var valid_578966 = query.getOrDefault("alt")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("json"))
  if valid_578966 != nil:
    section.add "alt", valid_578966
  var valid_578967 = query.getOrDefault("uploadType")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "uploadType", valid_578967
  var valid_578968 = query.getOrDefault("quotaUser")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "quotaUser", valid_578968
  var valid_578969 = query.getOrDefault("callback")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "callback", valid_578969
  var valid_578970 = query.getOrDefault("fields")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "fields", valid_578970
  var valid_578971 = query.getOrDefault("access_token")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "access_token", valid_578971
  var valid_578972 = query.getOrDefault("upload_protocol")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "upload_protocol", valid_578972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578973: Call_CloudresourcemanagerFoldersGet_578958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Folder identified by the supplied resource name.
  ## Valid Folder resource names have the format `folders/{folder_id}`
  ## (for example, `folders/1234`).
  ## The caller must have `resourcemanager.folders.get` permission on the
  ## identified folder.
  ## 
  let valid = call_578973.validator(path, query, header, formData, body)
  let scheme = call_578973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578973.url(scheme.get, call_578973.host, call_578973.base,
                         call_578973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578973, url, valid)

proc call*(call_578974: Call_CloudresourcemanagerFoldersGet_578958; name: string;
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
  ##       : The resource name of the Folder to retrieve.
  ## Must be of the form `folders/{folder_id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578975 = newJObject()
  var query_578976 = newJObject()
  add(query_578976, "key", newJString(key))
  add(query_578976, "prettyPrint", newJBool(prettyPrint))
  add(query_578976, "oauth_token", newJString(oauthToken))
  add(query_578976, "$.xgafv", newJString(Xgafv))
  add(query_578976, "alt", newJString(alt))
  add(query_578976, "uploadType", newJString(uploadType))
  add(query_578976, "quotaUser", newJString(quotaUser))
  add(path_578975, "name", newJString(name))
  add(query_578976, "callback", newJString(callback))
  add(query_578976, "fields", newJString(fields))
  add(query_578976, "access_token", newJString(accessToken))
  add(query_578976, "upload_protocol", newJString(uploadProtocol))
  result = call_578974.call(path_578975, query_578976, nil, nil, nil)

var cloudresourcemanagerFoldersGet* = Call_CloudresourcemanagerFoldersGet_578958(
    name: "cloudresourcemanagerFoldersGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersGet_578959, base: "/",
    url: url_CloudresourcemanagerFoldersGet_578960, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersPatch_578996 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersPatch_578998(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersPatch_578997(path: JsonNode;
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
  var valid_578999 = path.getOrDefault("name")
  valid_578999 = validateParameter(valid_578999, JString, required = true,
                                 default = nil)
  if valid_578999 != nil:
    section.add "name", valid_578999
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
  ##             : Fields to be updated.
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
  var valid_579000 = query.getOrDefault("key")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "key", valid_579000
  var valid_579001 = query.getOrDefault("prettyPrint")
  valid_579001 = validateParameter(valid_579001, JBool, required = false,
                                 default = newJBool(true))
  if valid_579001 != nil:
    section.add "prettyPrint", valid_579001
  var valid_579002 = query.getOrDefault("oauth_token")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "oauth_token", valid_579002
  var valid_579003 = query.getOrDefault("$.xgafv")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = newJString("1"))
  if valid_579003 != nil:
    section.add "$.xgafv", valid_579003
  var valid_579004 = query.getOrDefault("alt")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("json"))
  if valid_579004 != nil:
    section.add "alt", valid_579004
  var valid_579005 = query.getOrDefault("uploadType")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "uploadType", valid_579005
  var valid_579006 = query.getOrDefault("quotaUser")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "quotaUser", valid_579006
  var valid_579007 = query.getOrDefault("updateMask")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "updateMask", valid_579007
  var valid_579008 = query.getOrDefault("callback")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "callback", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
  var valid_579010 = query.getOrDefault("access_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "access_token", valid_579010
  var valid_579011 = query.getOrDefault("upload_protocol")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "upload_protocol", valid_579011
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

proc call*(call_579013: Call_CloudresourcemanagerFoldersPatch_578996;
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
  let valid = call_579013.validator(path, query, header, formData, body)
  let scheme = call_579013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579013.url(scheme.get, call_579013.host, call_579013.base,
                         call_579013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579013, url, valid)

proc call*(call_579014: Call_CloudresourcemanagerFoldersPatch_578996; name: string;
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
  ##             : Fields to be updated.
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
  var path_579015 = newJObject()
  var query_579016 = newJObject()
  var body_579017 = newJObject()
  add(query_579016, "key", newJString(key))
  add(query_579016, "prettyPrint", newJBool(prettyPrint))
  add(query_579016, "oauth_token", newJString(oauthToken))
  add(query_579016, "$.xgafv", newJString(Xgafv))
  add(query_579016, "alt", newJString(alt))
  add(query_579016, "uploadType", newJString(uploadType))
  add(query_579016, "quotaUser", newJString(quotaUser))
  add(path_579015, "name", newJString(name))
  add(query_579016, "updateMask", newJString(updateMask))
  if body != nil:
    body_579017 = body
  add(query_579016, "callback", newJString(callback))
  add(query_579016, "fields", newJString(fields))
  add(query_579016, "access_token", newJString(accessToken))
  add(query_579016, "upload_protocol", newJString(uploadProtocol))
  result = call_579014.call(path_579015, query_579016, nil, nil, body_579017)

var cloudresourcemanagerFoldersPatch* = Call_CloudresourcemanagerFoldersPatch_578996(
    name: "cloudresourcemanagerFoldersPatch", meth: HttpMethod.HttpPatch,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersPatch_578997, base: "/",
    url: url_CloudresourcemanagerFoldersPatch_578998, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersDelete_578977 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersDelete_578979(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersDelete_578978(path: JsonNode;
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
  ##       : the resource name of the Folder to be deleted.
  ## Must be of the form `folders/{folder_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578980 = path.getOrDefault("name")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "name", valid_578980
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
  var valid_578981 = query.getOrDefault("key")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "key", valid_578981
  var valid_578982 = query.getOrDefault("prettyPrint")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "prettyPrint", valid_578982
  var valid_578983 = query.getOrDefault("oauth_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "oauth_token", valid_578983
  var valid_578984 = query.getOrDefault("$.xgafv")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("1"))
  if valid_578984 != nil:
    section.add "$.xgafv", valid_578984
  var valid_578985 = query.getOrDefault("alt")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("json"))
  if valid_578985 != nil:
    section.add "alt", valid_578985
  var valid_578986 = query.getOrDefault("uploadType")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "uploadType", valid_578986
  var valid_578987 = query.getOrDefault("quotaUser")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "quotaUser", valid_578987
  var valid_578988 = query.getOrDefault("callback")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "callback", valid_578988
  var valid_578989 = query.getOrDefault("fields")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "fields", valid_578989
  var valid_578990 = query.getOrDefault("access_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "access_token", valid_578990
  var valid_578991 = query.getOrDefault("upload_protocol")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "upload_protocol", valid_578991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578992: Call_CloudresourcemanagerFoldersDelete_578977;
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
  let valid = call_578992.validator(path, query, header, formData, body)
  let scheme = call_578992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578992.url(scheme.get, call_578992.host, call_578992.base,
                         call_578992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578992, url, valid)

proc call*(call_578993: Call_CloudresourcemanagerFoldersDelete_578977;
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
  ##       : the resource name of the Folder to be deleted.
  ## Must be of the form `folders/{folder_id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578994 = newJObject()
  var query_578995 = newJObject()
  add(query_578995, "key", newJString(key))
  add(query_578995, "prettyPrint", newJBool(prettyPrint))
  add(query_578995, "oauth_token", newJString(oauthToken))
  add(query_578995, "$.xgafv", newJString(Xgafv))
  add(query_578995, "alt", newJString(alt))
  add(query_578995, "uploadType", newJString(uploadType))
  add(query_578995, "quotaUser", newJString(quotaUser))
  add(path_578994, "name", newJString(name))
  add(query_578995, "callback", newJString(callback))
  add(query_578995, "fields", newJString(fields))
  add(query_578995, "access_token", newJString(accessToken))
  add(query_578995, "upload_protocol", newJString(uploadProtocol))
  result = call_578993.call(path_578994, query_578995, nil, nil, nil)

var cloudresourcemanagerFoldersDelete* = Call_CloudresourcemanagerFoldersDelete_578977(
    name: "cloudresourcemanagerFoldersDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersDelete_578978, base: "/",
    url: url_CloudresourcemanagerFoldersDelete_578979, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersMove_579018 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersMove_579020(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersMove_579019(path: JsonNode;
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
  ##       : The resource name of the Folder to move.
  ## Must be of the form folders/{folder_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579021 = path.getOrDefault("name")
  valid_579021 = validateParameter(valid_579021, JString, required = true,
                                 default = nil)
  if valid_579021 != nil:
    section.add "name", valid_579021
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
  var valid_579022 = query.getOrDefault("key")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "key", valid_579022
  var valid_579023 = query.getOrDefault("prettyPrint")
  valid_579023 = validateParameter(valid_579023, JBool, required = false,
                                 default = newJBool(true))
  if valid_579023 != nil:
    section.add "prettyPrint", valid_579023
  var valid_579024 = query.getOrDefault("oauth_token")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "oauth_token", valid_579024
  var valid_579025 = query.getOrDefault("$.xgafv")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = newJString("1"))
  if valid_579025 != nil:
    section.add "$.xgafv", valid_579025
  var valid_579026 = query.getOrDefault("alt")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = newJString("json"))
  if valid_579026 != nil:
    section.add "alt", valid_579026
  var valid_579027 = query.getOrDefault("uploadType")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "uploadType", valid_579027
  var valid_579028 = query.getOrDefault("quotaUser")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "quotaUser", valid_579028
  var valid_579029 = query.getOrDefault("callback")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "callback", valid_579029
  var valid_579030 = query.getOrDefault("fields")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "fields", valid_579030
  var valid_579031 = query.getOrDefault("access_token")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "access_token", valid_579031
  var valid_579032 = query.getOrDefault("upload_protocol")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "upload_protocol", valid_579032
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

proc call*(call_579034: Call_CloudresourcemanagerFoldersMove_579018;
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
  let valid = call_579034.validator(path, query, header, formData, body)
  let scheme = call_579034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579034.url(scheme.get, call_579034.host, call_579034.base,
                         call_579034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579034, url, valid)

proc call*(call_579035: Call_CloudresourcemanagerFoldersMove_579018; name: string;
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
  ##       : The resource name of the Folder to move.
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
  var path_579036 = newJObject()
  var query_579037 = newJObject()
  var body_579038 = newJObject()
  add(query_579037, "key", newJString(key))
  add(query_579037, "prettyPrint", newJBool(prettyPrint))
  add(query_579037, "oauth_token", newJString(oauthToken))
  add(query_579037, "$.xgafv", newJString(Xgafv))
  add(query_579037, "alt", newJString(alt))
  add(query_579037, "uploadType", newJString(uploadType))
  add(query_579037, "quotaUser", newJString(quotaUser))
  add(path_579036, "name", newJString(name))
  if body != nil:
    body_579038 = body
  add(query_579037, "callback", newJString(callback))
  add(query_579037, "fields", newJString(fields))
  add(query_579037, "access_token", newJString(accessToken))
  add(query_579037, "upload_protocol", newJString(uploadProtocol))
  result = call_579035.call(path_579036, query_579037, nil, nil, body_579038)

var cloudresourcemanagerFoldersMove* = Call_CloudresourcemanagerFoldersMove_579018(
    name: "cloudresourcemanagerFoldersMove", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}:move",
    validator: validate_CloudresourcemanagerFoldersMove_579019, base: "/",
    url: url_CloudresourcemanagerFoldersMove_579020, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersUndelete_579039 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersUndelete_579041(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersUndelete_579040(path: JsonNode;
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
  ##       : The resource name of the Folder to undelete.
  ## Must be of the form `folders/{folder_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579042 = path.getOrDefault("name")
  valid_579042 = validateParameter(valid_579042, JString, required = true,
                                 default = nil)
  if valid_579042 != nil:
    section.add "name", valid_579042
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
  var valid_579043 = query.getOrDefault("key")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "key", valid_579043
  var valid_579044 = query.getOrDefault("prettyPrint")
  valid_579044 = validateParameter(valid_579044, JBool, required = false,
                                 default = newJBool(true))
  if valid_579044 != nil:
    section.add "prettyPrint", valid_579044
  var valid_579045 = query.getOrDefault("oauth_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "oauth_token", valid_579045
  var valid_579046 = query.getOrDefault("$.xgafv")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("1"))
  if valid_579046 != nil:
    section.add "$.xgafv", valid_579046
  var valid_579047 = query.getOrDefault("alt")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = newJString("json"))
  if valid_579047 != nil:
    section.add "alt", valid_579047
  var valid_579048 = query.getOrDefault("uploadType")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "uploadType", valid_579048
  var valid_579049 = query.getOrDefault("quotaUser")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "quotaUser", valid_579049
  var valid_579050 = query.getOrDefault("callback")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "callback", valid_579050
  var valid_579051 = query.getOrDefault("fields")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "fields", valid_579051
  var valid_579052 = query.getOrDefault("access_token")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "access_token", valid_579052
  var valid_579053 = query.getOrDefault("upload_protocol")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "upload_protocol", valid_579053
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

proc call*(call_579055: Call_CloudresourcemanagerFoldersUndelete_579039;
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
  let valid = call_579055.validator(path, query, header, formData, body)
  let scheme = call_579055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579055.url(scheme.get, call_579055.host, call_579055.base,
                         call_579055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579055, url, valid)

proc call*(call_579056: Call_CloudresourcemanagerFoldersUndelete_579039;
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
  ##       : The resource name of the Folder to undelete.
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
  var path_579057 = newJObject()
  var query_579058 = newJObject()
  var body_579059 = newJObject()
  add(query_579058, "key", newJString(key))
  add(query_579058, "prettyPrint", newJBool(prettyPrint))
  add(query_579058, "oauth_token", newJString(oauthToken))
  add(query_579058, "$.xgafv", newJString(Xgafv))
  add(query_579058, "alt", newJString(alt))
  add(query_579058, "uploadType", newJString(uploadType))
  add(query_579058, "quotaUser", newJString(quotaUser))
  add(path_579057, "name", newJString(name))
  if body != nil:
    body_579059 = body
  add(query_579058, "callback", newJString(callback))
  add(query_579058, "fields", newJString(fields))
  add(query_579058, "access_token", newJString(accessToken))
  add(query_579058, "upload_protocol", newJString(uploadProtocol))
  result = call_579056.call(path_579057, query_579058, nil, nil, body_579059)

var cloudresourcemanagerFoldersUndelete* = Call_CloudresourcemanagerFoldersUndelete_579039(
    name: "cloudresourcemanagerFoldersUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}:undelete",
    validator: validate_CloudresourcemanagerFoldersUndelete_579040, base: "/",
    url: url_CloudresourcemanagerFoldersUndelete_579041, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersGetIamPolicy_579060 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersGetIamPolicy_579062(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersGetIamPolicy_579061(path: JsonNode;
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
  var valid_579063 = path.getOrDefault("resource")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "resource", valid_579063
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
  var valid_579064 = query.getOrDefault("key")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "key", valid_579064
  var valid_579065 = query.getOrDefault("prettyPrint")
  valid_579065 = validateParameter(valid_579065, JBool, required = false,
                                 default = newJBool(true))
  if valid_579065 != nil:
    section.add "prettyPrint", valid_579065
  var valid_579066 = query.getOrDefault("oauth_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "oauth_token", valid_579066
  var valid_579067 = query.getOrDefault("$.xgafv")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = newJString("1"))
  if valid_579067 != nil:
    section.add "$.xgafv", valid_579067
  var valid_579068 = query.getOrDefault("alt")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = newJString("json"))
  if valid_579068 != nil:
    section.add "alt", valid_579068
  var valid_579069 = query.getOrDefault("uploadType")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "uploadType", valid_579069
  var valid_579070 = query.getOrDefault("quotaUser")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "quotaUser", valid_579070
  var valid_579071 = query.getOrDefault("callback")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "callback", valid_579071
  var valid_579072 = query.getOrDefault("fields")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "fields", valid_579072
  var valid_579073 = query.getOrDefault("access_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "access_token", valid_579073
  var valid_579074 = query.getOrDefault("upload_protocol")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "upload_protocol", valid_579074
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

proc call*(call_579076: Call_CloudresourcemanagerFoldersGetIamPolicy_579060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a Folder. The returned policy may be
  ## empty if no such policy or resource exists. The `resource` field should
  ## be the Folder's resource name, e.g. "folders/1234".
  ## The caller must have `resourcemanager.folders.getIamPolicy` permission
  ## on the identified folder.
  ## 
  let valid = call_579076.validator(path, query, header, formData, body)
  let scheme = call_579076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579076.url(scheme.get, call_579076.host, call_579076.base,
                         call_579076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579076, url, valid)

proc call*(call_579077: Call_CloudresourcemanagerFoldersGetIamPolicy_579060;
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
  var path_579078 = newJObject()
  var query_579079 = newJObject()
  var body_579080 = newJObject()
  add(query_579079, "key", newJString(key))
  add(query_579079, "prettyPrint", newJBool(prettyPrint))
  add(query_579079, "oauth_token", newJString(oauthToken))
  add(query_579079, "$.xgafv", newJString(Xgafv))
  add(query_579079, "alt", newJString(alt))
  add(query_579079, "uploadType", newJString(uploadType))
  add(query_579079, "quotaUser", newJString(quotaUser))
  add(path_579078, "resource", newJString(resource))
  if body != nil:
    body_579080 = body
  add(query_579079, "callback", newJString(callback))
  add(query_579079, "fields", newJString(fields))
  add(query_579079, "access_token", newJString(accessToken))
  add(query_579079, "upload_protocol", newJString(uploadProtocol))
  result = call_579077.call(path_579078, query_579079, nil, nil, body_579080)

var cloudresourcemanagerFoldersGetIamPolicy* = Call_CloudresourcemanagerFoldersGetIamPolicy_579060(
    name: "cloudresourcemanagerFoldersGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerFoldersGetIamPolicy_579061, base: "/",
    url: url_CloudresourcemanagerFoldersGetIamPolicy_579062,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersSetIamPolicy_579081 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersSetIamPolicy_579083(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersSetIamPolicy_579082(path: JsonNode;
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
  var valid_579084 = path.getOrDefault("resource")
  valid_579084 = validateParameter(valid_579084, JString, required = true,
                                 default = nil)
  if valid_579084 != nil:
    section.add "resource", valid_579084
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
  var valid_579085 = query.getOrDefault("key")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "key", valid_579085
  var valid_579086 = query.getOrDefault("prettyPrint")
  valid_579086 = validateParameter(valid_579086, JBool, required = false,
                                 default = newJBool(true))
  if valid_579086 != nil:
    section.add "prettyPrint", valid_579086
  var valid_579087 = query.getOrDefault("oauth_token")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "oauth_token", valid_579087
  var valid_579088 = query.getOrDefault("$.xgafv")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = newJString("1"))
  if valid_579088 != nil:
    section.add "$.xgafv", valid_579088
  var valid_579089 = query.getOrDefault("alt")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = newJString("json"))
  if valid_579089 != nil:
    section.add "alt", valid_579089
  var valid_579090 = query.getOrDefault("uploadType")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "uploadType", valid_579090
  var valid_579091 = query.getOrDefault("quotaUser")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "quotaUser", valid_579091
  var valid_579092 = query.getOrDefault("callback")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "callback", valid_579092
  var valid_579093 = query.getOrDefault("fields")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "fields", valid_579093
  var valid_579094 = query.getOrDefault("access_token")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "access_token", valid_579094
  var valid_579095 = query.getOrDefault("upload_protocol")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "upload_protocol", valid_579095
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

proc call*(call_579097: Call_CloudresourcemanagerFoldersSetIamPolicy_579081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on a Folder, replacing any existing policy.
  ## The `resource` field should be the Folder's resource name, e.g.
  ## "folders/1234".
  ## The caller must have `resourcemanager.folders.setIamPolicy` permission
  ## on the identified folder.
  ## 
  let valid = call_579097.validator(path, query, header, formData, body)
  let scheme = call_579097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579097.url(scheme.get, call_579097.host, call_579097.base,
                         call_579097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579097, url, valid)

proc call*(call_579098: Call_CloudresourcemanagerFoldersSetIamPolicy_579081;
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
  var path_579099 = newJObject()
  var query_579100 = newJObject()
  var body_579101 = newJObject()
  add(query_579100, "key", newJString(key))
  add(query_579100, "prettyPrint", newJBool(prettyPrint))
  add(query_579100, "oauth_token", newJString(oauthToken))
  add(query_579100, "$.xgafv", newJString(Xgafv))
  add(query_579100, "alt", newJString(alt))
  add(query_579100, "uploadType", newJString(uploadType))
  add(query_579100, "quotaUser", newJString(quotaUser))
  add(path_579099, "resource", newJString(resource))
  if body != nil:
    body_579101 = body
  add(query_579100, "callback", newJString(callback))
  add(query_579100, "fields", newJString(fields))
  add(query_579100, "access_token", newJString(accessToken))
  add(query_579100, "upload_protocol", newJString(uploadProtocol))
  result = call_579098.call(path_579099, query_579100, nil, nil, body_579101)

var cloudresourcemanagerFoldersSetIamPolicy* = Call_CloudresourcemanagerFoldersSetIamPolicy_579081(
    name: "cloudresourcemanagerFoldersSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerFoldersSetIamPolicy_579082, base: "/",
    url: url_CloudresourcemanagerFoldersSetIamPolicy_579083,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersTestIamPermissions_579102 = ref object of OpenApiRestCall_578339
proc url_CloudresourcemanagerFoldersTestIamPermissions_579104(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersTestIamPermissions_579103(
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
  var valid_579105 = path.getOrDefault("resource")
  valid_579105 = validateParameter(valid_579105, JString, required = true,
                                 default = nil)
  if valid_579105 != nil:
    section.add "resource", valid_579105
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
  var valid_579106 = query.getOrDefault("key")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "key", valid_579106
  var valid_579107 = query.getOrDefault("prettyPrint")
  valid_579107 = validateParameter(valid_579107, JBool, required = false,
                                 default = newJBool(true))
  if valid_579107 != nil:
    section.add "prettyPrint", valid_579107
  var valid_579108 = query.getOrDefault("oauth_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "oauth_token", valid_579108
  var valid_579109 = query.getOrDefault("$.xgafv")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = newJString("1"))
  if valid_579109 != nil:
    section.add "$.xgafv", valid_579109
  var valid_579110 = query.getOrDefault("alt")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = newJString("json"))
  if valid_579110 != nil:
    section.add "alt", valid_579110
  var valid_579111 = query.getOrDefault("uploadType")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "uploadType", valid_579111
  var valid_579112 = query.getOrDefault("quotaUser")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "quotaUser", valid_579112
  var valid_579113 = query.getOrDefault("callback")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "callback", valid_579113
  var valid_579114 = query.getOrDefault("fields")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "fields", valid_579114
  var valid_579115 = query.getOrDefault("access_token")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "access_token", valid_579115
  var valid_579116 = query.getOrDefault("upload_protocol")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "upload_protocol", valid_579116
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

proc call*(call_579118: Call_CloudresourcemanagerFoldersTestIamPermissions_579102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Folder.
  ## The `resource` field should be the Folder's resource name,
  ## e.g. "folders/1234".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_579118.validator(path, query, header, formData, body)
  let scheme = call_579118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579118.url(scheme.get, call_579118.host, call_579118.base,
                         call_579118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579118, url, valid)

proc call*(call_579119: Call_CloudresourcemanagerFoldersTestIamPermissions_579102;
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
  var path_579120 = newJObject()
  var query_579121 = newJObject()
  var body_579122 = newJObject()
  add(query_579121, "key", newJString(key))
  add(query_579121, "prettyPrint", newJBool(prettyPrint))
  add(query_579121, "oauth_token", newJString(oauthToken))
  add(query_579121, "$.xgafv", newJString(Xgafv))
  add(query_579121, "alt", newJString(alt))
  add(query_579121, "uploadType", newJString(uploadType))
  add(query_579121, "quotaUser", newJString(quotaUser))
  add(path_579120, "resource", newJString(resource))
  if body != nil:
    body_579122 = body
  add(query_579121, "callback", newJString(callback))
  add(query_579121, "fields", newJString(fields))
  add(query_579121, "access_token", newJString(accessToken))
  add(query_579121, "upload_protocol", newJString(uploadProtocol))
  result = call_579119.call(path_579120, query_579121, nil, nil, body_579122)

var cloudresourcemanagerFoldersTestIamPermissions* = Call_CloudresourcemanagerFoldersTestIamPermissions_579102(
    name: "cloudresourcemanagerFoldersTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerFoldersTestIamPermissions_579103,
    base: "/", url: url_CloudresourcemanagerFoldersTestIamPermissions_579104,
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
