
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "cloudresourcemanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudresourcemanagerOperationsGet_579677 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerOperationsGet_579679(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerOperationsGet_579678(path: JsonNode;
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
  var valid_579805 = path.getOrDefault("name")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "name", valid_579805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("callback")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "callback", valid_579824
  var valid_579825 = query.getOrDefault("access_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "access_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579852: Call_CloudresourcemanagerOperationsGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_CloudresourcemanagerOperationsGet_579677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579924 = newJObject()
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(path_579924, "name", newJString(name))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(path_579924, query_579926, nil, nil, nil)

var cloudresourcemanagerOperationsGet* = Call_CloudresourcemanagerOperationsGet_579677(
    name: "cloudresourcemanagerOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerOperationsGet_579678, base: "/",
    url: url_CloudresourcemanagerOperationsGet_579679, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersCreate_579986 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersCreate_579988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersCreate_579987(path: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The resource name of the new Folder's parent.
  ## Must be of the form `folders/{folder_id}` or `organizations/{org_id}`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579989 = query.getOrDefault("upload_protocol")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "upload_protocol", valid_579989
  var valid_579990 = query.getOrDefault("fields")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "fields", valid_579990
  var valid_579991 = query.getOrDefault("quotaUser")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "quotaUser", valid_579991
  var valid_579992 = query.getOrDefault("alt")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("json"))
  if valid_579992 != nil:
    section.add "alt", valid_579992
  var valid_579993 = query.getOrDefault("oauth_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "oauth_token", valid_579993
  var valid_579994 = query.getOrDefault("callback")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "callback", valid_579994
  var valid_579995 = query.getOrDefault("access_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "access_token", valid_579995
  var valid_579996 = query.getOrDefault("uploadType")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "uploadType", valid_579996
  var valid_579997 = query.getOrDefault("parent")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "parent", valid_579997
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("$.xgafv")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("1"))
  if valid_579999 != nil:
    section.add "$.xgafv", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
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

proc call*(call_580002: Call_CloudresourcemanagerFoldersCreate_579986;
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
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_CloudresourcemanagerFoldersCreate_579986;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; parent: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The resource name of the new Folder's parent.
  ## Must be of the form `folders/{folder_id}` or `organizations/{org_id}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580004 = newJObject()
  var body_580005 = newJObject()
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "uploadType", newJString(uploadType))
  add(query_580004, "parent", newJString(parent))
  add(query_580004, "key", newJString(key))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580005 = body
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  result = call_580003.call(nil, query_580004, nil, nil, body_580005)

var cloudresourcemanagerFoldersCreate* = Call_CloudresourcemanagerFoldersCreate_579986(
    name: "cloudresourcemanagerFoldersCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders",
    validator: validate_CloudresourcemanagerFoldersCreate_579987, base: "/",
    url: url_CloudresourcemanagerFoldersCreate_579988, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersList_579965 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersList_579967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersList_579966(path: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to `ListFolders`
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The resource name of the Organization or Folder whose Folders are
  ## being listed.
  ## Must be of the form `folders/{folder_id}` or `organizations/{org_id}`.
  ## Access to this method is controlled by checking the
  ## `resourcemanager.folders.list` permission on the `parent`.
  ##   showDeleted: JBool
  ##              : Controls whether Folders in the
  ## DELETE_REQUESTED
  ## state should be returned. Defaults to false. This field is optional.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of Folders to return in the response.
  ## This field is optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579968 = query.getOrDefault("upload_protocol")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "upload_protocol", valid_579968
  var valid_579969 = query.getOrDefault("fields")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "fields", valid_579969
  var valid_579970 = query.getOrDefault("pageToken")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "pageToken", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("parent")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "parent", valid_579977
  var valid_579978 = query.getOrDefault("showDeleted")
  valid_579978 = validateParameter(valid_579978, JBool, required = false, default = nil)
  if valid_579978 != nil:
    section.add "showDeleted", valid_579978
  var valid_579979 = query.getOrDefault("key")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "key", valid_579979
  var valid_579980 = query.getOrDefault("$.xgafv")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("1"))
  if valid_579980 != nil:
    section.add "$.xgafv", valid_579980
  var valid_579981 = query.getOrDefault("pageSize")
  valid_579981 = validateParameter(valid_579981, JInt, required = false, default = nil)
  if valid_579981 != nil:
    section.add "pageSize", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579983: Call_CloudresourcemanagerFoldersList_579965;
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
  let valid = call_579983.validator(path, query, header, formData, body)
  let scheme = call_579983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579983.url(scheme.get, call_579983.host, call_579983.base,
                         call_579983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579983, url, valid)

proc call*(call_579984: Call_CloudresourcemanagerFoldersList_579965;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          parent: string = ""; showDeleted: bool = false; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerFoldersList
  ## Lists the Folders that are direct descendants of supplied parent resource.
  ## List provides a strongly consistent view of the Folders underneath
  ## the specified parent resource.
  ## List returns Folders sorted based upon the (ascending) lexical ordering
  ## of their display_name.
  ## The caller must have `resourcemanager.folders.list` permission on the
  ## identified parent.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to `ListFolders`
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The resource name of the Organization or Folder whose Folders are
  ## being listed.
  ## Must be of the form `folders/{folder_id}` or `organizations/{org_id}`.
  ## Access to this method is controlled by checking the
  ## `resourcemanager.folders.list` permission on the `parent`.
  ##   showDeleted: bool
  ##              : Controls whether Folders in the
  ## DELETE_REQUESTED
  ## state should be returned. Defaults to false. This field is optional.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Folders to return in the response.
  ## This field is optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579985 = newJObject()
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "pageToken", newJString(pageToken))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "uploadType", newJString(uploadType))
  add(query_579985, "parent", newJString(parent))
  add(query_579985, "showDeleted", newJBool(showDeleted))
  add(query_579985, "key", newJString(key))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  add(query_579985, "pageSize", newJInt(pageSize))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  result = call_579984.call(nil, query_579985, nil, nil, nil)

var cloudresourcemanagerFoldersList* = Call_CloudresourcemanagerFoldersList_579965(
    name: "cloudresourcemanagerFoldersList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders",
    validator: validate_CloudresourcemanagerFoldersList_579966, base: "/",
    url: url_CloudresourcemanagerFoldersList_579967, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersSearch_580006 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersSearch_580008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersSearch_580007(path: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580009 = query.getOrDefault("upload_protocol")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "upload_protocol", valid_580009
  var valid_580010 = query.getOrDefault("fields")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "fields", valid_580010
  var valid_580011 = query.getOrDefault("quotaUser")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "quotaUser", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("callback")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "callback", valid_580014
  var valid_580015 = query.getOrDefault("access_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "access_token", valid_580015
  var valid_580016 = query.getOrDefault("uploadType")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "uploadType", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("$.xgafv")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("1"))
  if valid_580018 != nil:
    section.add "$.xgafv", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
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

proc call*(call_580021: Call_CloudresourcemanagerFoldersSearch_580006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search for folders that match specific filter criteria.
  ## Search provides an eventually consistent view of the folders a user has
  ## access to which meet the specified filter criteria.
  ## 
  ## This will only return folders on which the caller has the
  ## permission `resourcemanager.folders.get`.
  ## 
  let valid = call_580021.validator(path, query, header, formData, body)
  let scheme = call_580021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580021.url(scheme.get, call_580021.host, call_580021.base,
                         call_580021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580021, url, valid)

proc call*(call_580022: Call_CloudresourcemanagerFoldersSearch_580006;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerFoldersSearch
  ## Search for folders that match specific filter criteria.
  ## Search provides an eventually consistent view of the folders a user has
  ## access to which meet the specified filter criteria.
  ## 
  ## This will only return folders on which the caller has the
  ## permission `resourcemanager.folders.get`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580023 = newJObject()
  var body_580024 = newJObject()
  add(query_580023, "upload_protocol", newJString(uploadProtocol))
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "callback", newJString(callback))
  add(query_580023, "access_token", newJString(accessToken))
  add(query_580023, "uploadType", newJString(uploadType))
  add(query_580023, "key", newJString(key))
  add(query_580023, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580024 = body
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  result = call_580022.call(nil, query_580023, nil, nil, body_580024)

var cloudresourcemanagerFoldersSearch* = Call_CloudresourcemanagerFoldersSearch_580006(
    name: "cloudresourcemanagerFoldersSearch", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders:search",
    validator: validate_CloudresourcemanagerFoldersSearch_580007, base: "/",
    url: url_CloudresourcemanagerFoldersSearch_580008, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersGet_580025 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersGet_580027(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerFoldersGet_580026(path: JsonNode;
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
  var valid_580028 = path.getOrDefault("name")
  valid_580028 = validateParameter(valid_580028, JString, required = true,
                                 default = nil)
  if valid_580028 != nil:
    section.add "name", valid_580028
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580029 = query.getOrDefault("upload_protocol")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "upload_protocol", valid_580029
  var valid_580030 = query.getOrDefault("fields")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "fields", valid_580030
  var valid_580031 = query.getOrDefault("quotaUser")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "quotaUser", valid_580031
  var valid_580032 = query.getOrDefault("alt")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("json"))
  if valid_580032 != nil:
    section.add "alt", valid_580032
  var valid_580033 = query.getOrDefault("oauth_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "oauth_token", valid_580033
  var valid_580034 = query.getOrDefault("callback")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "callback", valid_580034
  var valid_580035 = query.getOrDefault("access_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "access_token", valid_580035
  var valid_580036 = query.getOrDefault("uploadType")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "uploadType", valid_580036
  var valid_580037 = query.getOrDefault("key")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "key", valid_580037
  var valid_580038 = query.getOrDefault("$.xgafv")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("1"))
  if valid_580038 != nil:
    section.add "$.xgafv", valid_580038
  var valid_580039 = query.getOrDefault("prettyPrint")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(true))
  if valid_580039 != nil:
    section.add "prettyPrint", valid_580039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580040: Call_CloudresourcemanagerFoldersGet_580025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Folder identified by the supplied resource name.
  ## Valid Folder resource names have the format `folders/{folder_id}`
  ## (for example, `folders/1234`).
  ## The caller must have `resourcemanager.folders.get` permission on the
  ## identified folder.
  ## 
  let valid = call_580040.validator(path, query, header, formData, body)
  let scheme = call_580040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580040.url(scheme.get, call_580040.host, call_580040.base,
                         call_580040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580040, url, valid)

proc call*(call_580041: Call_CloudresourcemanagerFoldersGet_580025; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerFoldersGet
  ## Retrieves a Folder identified by the supplied resource name.
  ## Valid Folder resource names have the format `folders/{folder_id}`
  ## (for example, `folders/1234`).
  ## The caller must have `resourcemanager.folders.get` permission on the
  ## identified folder.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the Folder to retrieve.
  ## Must be of the form `folders/{folder_id}`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580042 = newJObject()
  var query_580043 = newJObject()
  add(query_580043, "upload_protocol", newJString(uploadProtocol))
  add(query_580043, "fields", newJString(fields))
  add(query_580043, "quotaUser", newJString(quotaUser))
  add(path_580042, "name", newJString(name))
  add(query_580043, "alt", newJString(alt))
  add(query_580043, "oauth_token", newJString(oauthToken))
  add(query_580043, "callback", newJString(callback))
  add(query_580043, "access_token", newJString(accessToken))
  add(query_580043, "uploadType", newJString(uploadType))
  add(query_580043, "key", newJString(key))
  add(query_580043, "$.xgafv", newJString(Xgafv))
  add(query_580043, "prettyPrint", newJBool(prettyPrint))
  result = call_580041.call(path_580042, query_580043, nil, nil, nil)

var cloudresourcemanagerFoldersGet* = Call_CloudresourcemanagerFoldersGet_580025(
    name: "cloudresourcemanagerFoldersGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersGet_580026, base: "/",
    url: url_CloudresourcemanagerFoldersGet_580027, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersPatch_580063 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersPatch_580065(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerFoldersPatch_580064(path: JsonNode;
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
  var valid_580066 = path.getOrDefault("name")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "name", valid_580066
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Fields to be updated.
  ## Only the `display_name` can be updated.
  section = newJObject()
  var valid_580067 = query.getOrDefault("upload_protocol")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "upload_protocol", valid_580067
  var valid_580068 = query.getOrDefault("fields")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "fields", valid_580068
  var valid_580069 = query.getOrDefault("quotaUser")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "quotaUser", valid_580069
  var valid_580070 = query.getOrDefault("alt")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = newJString("json"))
  if valid_580070 != nil:
    section.add "alt", valid_580070
  var valid_580071 = query.getOrDefault("oauth_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "oauth_token", valid_580071
  var valid_580072 = query.getOrDefault("callback")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "callback", valid_580072
  var valid_580073 = query.getOrDefault("access_token")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "access_token", valid_580073
  var valid_580074 = query.getOrDefault("uploadType")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "uploadType", valid_580074
  var valid_580075 = query.getOrDefault("key")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "key", valid_580075
  var valid_580076 = query.getOrDefault("$.xgafv")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("1"))
  if valid_580076 != nil:
    section.add "$.xgafv", valid_580076
  var valid_580077 = query.getOrDefault("prettyPrint")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "prettyPrint", valid_580077
  var valid_580078 = query.getOrDefault("updateMask")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "updateMask", valid_580078
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

proc call*(call_580080: Call_CloudresourcemanagerFoldersPatch_580063;
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
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_CloudresourcemanagerFoldersPatch_580063; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The resource name of the Folder.
  ## Its format is `folders/{folder_id}`, for example: "folders/1234".
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Fields to be updated.
  ## Only the `display_name` can be updated.
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  var body_580084 = newJObject()
  add(query_580083, "upload_protocol", newJString(uploadProtocol))
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(path_580082, "name", newJString(name))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "callback", newJString(callback))
  add(query_580083, "access_token", newJString(accessToken))
  add(query_580083, "uploadType", newJString(uploadType))
  add(query_580083, "key", newJString(key))
  add(query_580083, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580084 = body
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  add(query_580083, "updateMask", newJString(updateMask))
  result = call_580081.call(path_580082, query_580083, nil, nil, body_580084)

var cloudresourcemanagerFoldersPatch* = Call_CloudresourcemanagerFoldersPatch_580063(
    name: "cloudresourcemanagerFoldersPatch", meth: HttpMethod.HttpPatch,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersPatch_580064, base: "/",
    url: url_CloudresourcemanagerFoldersPatch_580065, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersDelete_580044 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersDelete_580046(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerFoldersDelete_580045(path: JsonNode;
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
  var valid_580047 = path.getOrDefault("name")
  valid_580047 = validateParameter(valid_580047, JString, required = true,
                                 default = nil)
  if valid_580047 != nil:
    section.add "name", valid_580047
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580048 = query.getOrDefault("upload_protocol")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "upload_protocol", valid_580048
  var valid_580049 = query.getOrDefault("fields")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "fields", valid_580049
  var valid_580050 = query.getOrDefault("quotaUser")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "quotaUser", valid_580050
  var valid_580051 = query.getOrDefault("alt")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("json"))
  if valid_580051 != nil:
    section.add "alt", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("callback")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "callback", valid_580053
  var valid_580054 = query.getOrDefault("access_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "access_token", valid_580054
  var valid_580055 = query.getOrDefault("uploadType")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "uploadType", valid_580055
  var valid_580056 = query.getOrDefault("key")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "key", valid_580056
  var valid_580057 = query.getOrDefault("$.xgafv")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("1"))
  if valid_580057 != nil:
    section.add "$.xgafv", valid_580057
  var valid_580058 = query.getOrDefault("prettyPrint")
  valid_580058 = validateParameter(valid_580058, JBool, required = false,
                                 default = newJBool(true))
  if valid_580058 != nil:
    section.add "prettyPrint", valid_580058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580059: Call_CloudresourcemanagerFoldersDelete_580044;
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
  let valid = call_580059.validator(path, query, header, formData, body)
  let scheme = call_580059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580059.url(scheme.get, call_580059.host, call_580059.base,
                         call_580059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580059, url, valid)

proc call*(call_580060: Call_CloudresourcemanagerFoldersDelete_580044;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : the resource name of the Folder to be deleted.
  ## Must be of the form `folders/{folder_id}`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580061 = newJObject()
  var query_580062 = newJObject()
  add(query_580062, "upload_protocol", newJString(uploadProtocol))
  add(query_580062, "fields", newJString(fields))
  add(query_580062, "quotaUser", newJString(quotaUser))
  add(path_580061, "name", newJString(name))
  add(query_580062, "alt", newJString(alt))
  add(query_580062, "oauth_token", newJString(oauthToken))
  add(query_580062, "callback", newJString(callback))
  add(query_580062, "access_token", newJString(accessToken))
  add(query_580062, "uploadType", newJString(uploadType))
  add(query_580062, "key", newJString(key))
  add(query_580062, "$.xgafv", newJString(Xgafv))
  add(query_580062, "prettyPrint", newJBool(prettyPrint))
  result = call_580060.call(path_580061, query_580062, nil, nil, nil)

var cloudresourcemanagerFoldersDelete* = Call_CloudresourcemanagerFoldersDelete_580044(
    name: "cloudresourcemanagerFoldersDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersDelete_580045, base: "/",
    url: url_CloudresourcemanagerFoldersDelete_580046, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersMove_580085 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersMove_580087(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerFoldersMove_580086(path: JsonNode;
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
  var valid_580088 = path.getOrDefault("name")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "name", valid_580088
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580089 = query.getOrDefault("upload_protocol")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "upload_protocol", valid_580089
  var valid_580090 = query.getOrDefault("fields")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "fields", valid_580090
  var valid_580091 = query.getOrDefault("quotaUser")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "quotaUser", valid_580091
  var valid_580092 = query.getOrDefault("alt")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("json"))
  if valid_580092 != nil:
    section.add "alt", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("callback")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "callback", valid_580094
  var valid_580095 = query.getOrDefault("access_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "access_token", valid_580095
  var valid_580096 = query.getOrDefault("uploadType")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "uploadType", valid_580096
  var valid_580097 = query.getOrDefault("key")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "key", valid_580097
  var valid_580098 = query.getOrDefault("$.xgafv")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("1"))
  if valid_580098 != nil:
    section.add "$.xgafv", valid_580098
  var valid_580099 = query.getOrDefault("prettyPrint")
  valid_580099 = validateParameter(valid_580099, JBool, required = false,
                                 default = newJBool(true))
  if valid_580099 != nil:
    section.add "prettyPrint", valid_580099
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

proc call*(call_580101: Call_CloudresourcemanagerFoldersMove_580085;
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
  let valid = call_580101.validator(path, query, header, formData, body)
  let scheme = call_580101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580101.url(scheme.get, call_580101.host, call_580101.base,
                         call_580101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580101, url, valid)

proc call*(call_580102: Call_CloudresourcemanagerFoldersMove_580085; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the Folder to move.
  ## Must be of the form folders/{folder_id}
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580103 = newJObject()
  var query_580104 = newJObject()
  var body_580105 = newJObject()
  add(query_580104, "upload_protocol", newJString(uploadProtocol))
  add(query_580104, "fields", newJString(fields))
  add(query_580104, "quotaUser", newJString(quotaUser))
  add(path_580103, "name", newJString(name))
  add(query_580104, "alt", newJString(alt))
  add(query_580104, "oauth_token", newJString(oauthToken))
  add(query_580104, "callback", newJString(callback))
  add(query_580104, "access_token", newJString(accessToken))
  add(query_580104, "uploadType", newJString(uploadType))
  add(query_580104, "key", newJString(key))
  add(query_580104, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580105 = body
  add(query_580104, "prettyPrint", newJBool(prettyPrint))
  result = call_580102.call(path_580103, query_580104, nil, nil, body_580105)

var cloudresourcemanagerFoldersMove* = Call_CloudresourcemanagerFoldersMove_580085(
    name: "cloudresourcemanagerFoldersMove", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}:move",
    validator: validate_CloudresourcemanagerFoldersMove_580086, base: "/",
    url: url_CloudresourcemanagerFoldersMove_580087, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersUndelete_580106 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersUndelete_580108(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerFoldersUndelete_580107(path: JsonNode;
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
  var valid_580109 = path.getOrDefault("name")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "name", valid_580109
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580110 = query.getOrDefault("upload_protocol")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "upload_protocol", valid_580110
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("quotaUser")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "quotaUser", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("callback")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "callback", valid_580115
  var valid_580116 = query.getOrDefault("access_token")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "access_token", valid_580116
  var valid_580117 = query.getOrDefault("uploadType")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "uploadType", valid_580117
  var valid_580118 = query.getOrDefault("key")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "key", valid_580118
  var valid_580119 = query.getOrDefault("$.xgafv")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("1"))
  if valid_580119 != nil:
    section.add "$.xgafv", valid_580119
  var valid_580120 = query.getOrDefault("prettyPrint")
  valid_580120 = validateParameter(valid_580120, JBool, required = false,
                                 default = newJBool(true))
  if valid_580120 != nil:
    section.add "prettyPrint", valid_580120
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

proc call*(call_580122: Call_CloudresourcemanagerFoldersUndelete_580106;
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
  let valid = call_580122.validator(path, query, header, formData, body)
  let scheme = call_580122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580122.url(scheme.get, call_580122.host, call_580122.base,
                         call_580122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580122, url, valid)

proc call*(call_580123: Call_CloudresourcemanagerFoldersUndelete_580106;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the Folder to undelete.
  ## Must be of the form `folders/{folder_id}`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580124 = newJObject()
  var query_580125 = newJObject()
  var body_580126 = newJObject()
  add(query_580125, "upload_protocol", newJString(uploadProtocol))
  add(query_580125, "fields", newJString(fields))
  add(query_580125, "quotaUser", newJString(quotaUser))
  add(path_580124, "name", newJString(name))
  add(query_580125, "alt", newJString(alt))
  add(query_580125, "oauth_token", newJString(oauthToken))
  add(query_580125, "callback", newJString(callback))
  add(query_580125, "access_token", newJString(accessToken))
  add(query_580125, "uploadType", newJString(uploadType))
  add(query_580125, "key", newJString(key))
  add(query_580125, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580126 = body
  add(query_580125, "prettyPrint", newJBool(prettyPrint))
  result = call_580123.call(path_580124, query_580125, nil, nil, body_580126)

var cloudresourcemanagerFoldersUndelete* = Call_CloudresourcemanagerFoldersUndelete_580106(
    name: "cloudresourcemanagerFoldersUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}:undelete",
    validator: validate_CloudresourcemanagerFoldersUndelete_580107, base: "/",
    url: url_CloudresourcemanagerFoldersUndelete_580108, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersGetIamPolicy_580127 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersGetIamPolicy_580129(protocol: Scheme;
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

proc validate_CloudresourcemanagerFoldersGetIamPolicy_580128(path: JsonNode;
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
  var valid_580130 = path.getOrDefault("resource")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "resource", valid_580130
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580131 = query.getOrDefault("upload_protocol")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "upload_protocol", valid_580131
  var valid_580132 = query.getOrDefault("fields")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fields", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("oauth_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "oauth_token", valid_580135
  var valid_580136 = query.getOrDefault("callback")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "callback", valid_580136
  var valid_580137 = query.getOrDefault("access_token")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "access_token", valid_580137
  var valid_580138 = query.getOrDefault("uploadType")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "uploadType", valid_580138
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("$.xgafv")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("1"))
  if valid_580140 != nil:
    section.add "$.xgafv", valid_580140
  var valid_580141 = query.getOrDefault("prettyPrint")
  valid_580141 = validateParameter(valid_580141, JBool, required = false,
                                 default = newJBool(true))
  if valid_580141 != nil:
    section.add "prettyPrint", valid_580141
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

proc call*(call_580143: Call_CloudresourcemanagerFoldersGetIamPolicy_580127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a Folder. The returned policy may be
  ## empty if no such policy or resource exists. The `resource` field should
  ## be the Folder's resource name, e.g. "folders/1234".
  ## The caller must have `resourcemanager.folders.getIamPolicy` permission
  ## on the identified folder.
  ## 
  let valid = call_580143.validator(path, query, header, formData, body)
  let scheme = call_580143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580143.url(scheme.get, call_580143.host, call_580143.base,
                         call_580143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580143, url, valid)

proc call*(call_580144: Call_CloudresourcemanagerFoldersGetIamPolicy_580127;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerFoldersGetIamPolicy
  ## Gets the access control policy for a Folder. The returned policy may be
  ## empty if no such policy or resource exists. The `resource` field should
  ## be the Folder's resource name, e.g. "folders/1234".
  ## The caller must have `resourcemanager.folders.getIamPolicy` permission
  ## on the identified folder.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580145 = newJObject()
  var query_580146 = newJObject()
  var body_580147 = newJObject()
  add(query_580146, "upload_protocol", newJString(uploadProtocol))
  add(query_580146, "fields", newJString(fields))
  add(query_580146, "quotaUser", newJString(quotaUser))
  add(query_580146, "alt", newJString(alt))
  add(query_580146, "oauth_token", newJString(oauthToken))
  add(query_580146, "callback", newJString(callback))
  add(query_580146, "access_token", newJString(accessToken))
  add(query_580146, "uploadType", newJString(uploadType))
  add(query_580146, "key", newJString(key))
  add(query_580146, "$.xgafv", newJString(Xgafv))
  add(path_580145, "resource", newJString(resource))
  if body != nil:
    body_580147 = body
  add(query_580146, "prettyPrint", newJBool(prettyPrint))
  result = call_580144.call(path_580145, query_580146, nil, nil, body_580147)

var cloudresourcemanagerFoldersGetIamPolicy* = Call_CloudresourcemanagerFoldersGetIamPolicy_580127(
    name: "cloudresourcemanagerFoldersGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerFoldersGetIamPolicy_580128, base: "/",
    url: url_CloudresourcemanagerFoldersGetIamPolicy_580129,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersSetIamPolicy_580148 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersSetIamPolicy_580150(protocol: Scheme;
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

proc validate_CloudresourcemanagerFoldersSetIamPolicy_580149(path: JsonNode;
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
  var valid_580151 = path.getOrDefault("resource")
  valid_580151 = validateParameter(valid_580151, JString, required = true,
                                 default = nil)
  if valid_580151 != nil:
    section.add "resource", valid_580151
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580152 = query.getOrDefault("upload_protocol")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "upload_protocol", valid_580152
  var valid_580153 = query.getOrDefault("fields")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "fields", valid_580153
  var valid_580154 = query.getOrDefault("quotaUser")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "quotaUser", valid_580154
  var valid_580155 = query.getOrDefault("alt")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("json"))
  if valid_580155 != nil:
    section.add "alt", valid_580155
  var valid_580156 = query.getOrDefault("oauth_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "oauth_token", valid_580156
  var valid_580157 = query.getOrDefault("callback")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "callback", valid_580157
  var valid_580158 = query.getOrDefault("access_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "access_token", valid_580158
  var valid_580159 = query.getOrDefault("uploadType")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "uploadType", valid_580159
  var valid_580160 = query.getOrDefault("key")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "key", valid_580160
  var valid_580161 = query.getOrDefault("$.xgafv")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("1"))
  if valid_580161 != nil:
    section.add "$.xgafv", valid_580161
  var valid_580162 = query.getOrDefault("prettyPrint")
  valid_580162 = validateParameter(valid_580162, JBool, required = false,
                                 default = newJBool(true))
  if valid_580162 != nil:
    section.add "prettyPrint", valid_580162
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

proc call*(call_580164: Call_CloudresourcemanagerFoldersSetIamPolicy_580148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on a Folder, replacing any existing policy.
  ## The `resource` field should be the Folder's resource name, e.g.
  ## "folders/1234".
  ## The caller must have `resourcemanager.folders.setIamPolicy` permission
  ## on the identified folder.
  ## 
  let valid = call_580164.validator(path, query, header, formData, body)
  let scheme = call_580164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580164.url(scheme.get, call_580164.host, call_580164.base,
                         call_580164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580164, url, valid)

proc call*(call_580165: Call_CloudresourcemanagerFoldersSetIamPolicy_580148;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerFoldersSetIamPolicy
  ## Sets the access control policy on a Folder, replacing any existing policy.
  ## The `resource` field should be the Folder's resource name, e.g.
  ## "folders/1234".
  ## The caller must have `resourcemanager.folders.setIamPolicy` permission
  ## on the identified folder.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580166 = newJObject()
  var query_580167 = newJObject()
  var body_580168 = newJObject()
  add(query_580167, "upload_protocol", newJString(uploadProtocol))
  add(query_580167, "fields", newJString(fields))
  add(query_580167, "quotaUser", newJString(quotaUser))
  add(query_580167, "alt", newJString(alt))
  add(query_580167, "oauth_token", newJString(oauthToken))
  add(query_580167, "callback", newJString(callback))
  add(query_580167, "access_token", newJString(accessToken))
  add(query_580167, "uploadType", newJString(uploadType))
  add(query_580167, "key", newJString(key))
  add(query_580167, "$.xgafv", newJString(Xgafv))
  add(path_580166, "resource", newJString(resource))
  if body != nil:
    body_580168 = body
  add(query_580167, "prettyPrint", newJBool(prettyPrint))
  result = call_580165.call(path_580166, query_580167, nil, nil, body_580168)

var cloudresourcemanagerFoldersSetIamPolicy* = Call_CloudresourcemanagerFoldersSetIamPolicy_580148(
    name: "cloudresourcemanagerFoldersSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerFoldersSetIamPolicy_580149, base: "/",
    url: url_CloudresourcemanagerFoldersSetIamPolicy_580150,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersTestIamPermissions_580169 = ref object of OpenApiRestCall_579408
proc url_CloudresourcemanagerFoldersTestIamPermissions_580171(protocol: Scheme;
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

proc validate_CloudresourcemanagerFoldersTestIamPermissions_580170(
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
  var valid_580172 = path.getOrDefault("resource")
  valid_580172 = validateParameter(valid_580172, JString, required = true,
                                 default = nil)
  if valid_580172 != nil:
    section.add "resource", valid_580172
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580173 = query.getOrDefault("upload_protocol")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "upload_protocol", valid_580173
  var valid_580174 = query.getOrDefault("fields")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "fields", valid_580174
  var valid_580175 = query.getOrDefault("quotaUser")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "quotaUser", valid_580175
  var valid_580176 = query.getOrDefault("alt")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("json"))
  if valid_580176 != nil:
    section.add "alt", valid_580176
  var valid_580177 = query.getOrDefault("oauth_token")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "oauth_token", valid_580177
  var valid_580178 = query.getOrDefault("callback")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "callback", valid_580178
  var valid_580179 = query.getOrDefault("access_token")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "access_token", valid_580179
  var valid_580180 = query.getOrDefault("uploadType")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "uploadType", valid_580180
  var valid_580181 = query.getOrDefault("key")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "key", valid_580181
  var valid_580182 = query.getOrDefault("$.xgafv")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString("1"))
  if valid_580182 != nil:
    section.add "$.xgafv", valid_580182
  var valid_580183 = query.getOrDefault("prettyPrint")
  valid_580183 = validateParameter(valid_580183, JBool, required = false,
                                 default = newJBool(true))
  if valid_580183 != nil:
    section.add "prettyPrint", valid_580183
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

proc call*(call_580185: Call_CloudresourcemanagerFoldersTestIamPermissions_580169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Folder.
  ## The `resource` field should be the Folder's resource name,
  ## e.g. "folders/1234".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_580185.validator(path, query, header, formData, body)
  let scheme = call_580185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580185.url(scheme.get, call_580185.host, call_580185.base,
                         call_580185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580185, url, valid)

proc call*(call_580186: Call_CloudresourcemanagerFoldersTestIamPermissions_580169;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerFoldersTestIamPermissions
  ## Returns permissions that a caller has on the specified Folder.
  ## The `resource` field should be the Folder's resource name,
  ## e.g. "folders/1234".
  ## 
  ## There are no permissions required for making this API call.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580187 = newJObject()
  var query_580188 = newJObject()
  var body_580189 = newJObject()
  add(query_580188, "upload_protocol", newJString(uploadProtocol))
  add(query_580188, "fields", newJString(fields))
  add(query_580188, "quotaUser", newJString(quotaUser))
  add(query_580188, "alt", newJString(alt))
  add(query_580188, "oauth_token", newJString(oauthToken))
  add(query_580188, "callback", newJString(callback))
  add(query_580188, "access_token", newJString(accessToken))
  add(query_580188, "uploadType", newJString(uploadType))
  add(query_580188, "key", newJString(key))
  add(query_580188, "$.xgafv", newJString(Xgafv))
  add(path_580187, "resource", newJString(resource))
  if body != nil:
    body_580189 = body
  add(query_580188, "prettyPrint", newJBool(prettyPrint))
  result = call_580186.call(path_580187, query_580188, nil, nil, body_580189)

var cloudresourcemanagerFoldersTestIamPermissions* = Call_CloudresourcemanagerFoldersTestIamPermissions_580169(
    name: "cloudresourcemanagerFoldersTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerFoldersTestIamPermissions_580170,
    base: "/", url: url_CloudresourcemanagerFoldersTestIamPermissions_580171,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
