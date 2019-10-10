
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  Call_CloudresourcemanagerOperationsGet_588710 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerOperationsGet_588712(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerOperationsGet_588711(path: JsonNode;
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
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_CloudresourcemanagerOperationsGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_CloudresourcemanagerOperationsGet_588710;
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
  var path_588957 = newJObject()
  var query_588959 = newJObject()
  add(query_588959, "upload_protocol", newJString(uploadProtocol))
  add(query_588959, "fields", newJString(fields))
  add(query_588959, "quotaUser", newJString(quotaUser))
  add(path_588957, "name", newJString(name))
  add(query_588959, "alt", newJString(alt))
  add(query_588959, "oauth_token", newJString(oauthToken))
  add(query_588959, "callback", newJString(callback))
  add(query_588959, "access_token", newJString(accessToken))
  add(query_588959, "uploadType", newJString(uploadType))
  add(query_588959, "key", newJString(key))
  add(query_588959, "$.xgafv", newJString(Xgafv))
  add(query_588959, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(path_588957, query_588959, nil, nil, nil)

var cloudresourcemanagerOperationsGet* = Call_CloudresourcemanagerOperationsGet_588710(
    name: "cloudresourcemanagerOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerOperationsGet_588711, base: "/",
    url: url_CloudresourcemanagerOperationsGet_588712, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersCreate_589019 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersCreate_589021(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersCreate_589020(path: JsonNode;
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
  var valid_589022 = query.getOrDefault("upload_protocol")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "upload_protocol", valid_589022
  var valid_589023 = query.getOrDefault("fields")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "fields", valid_589023
  var valid_589024 = query.getOrDefault("quotaUser")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "quotaUser", valid_589024
  var valid_589025 = query.getOrDefault("alt")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("json"))
  if valid_589025 != nil:
    section.add "alt", valid_589025
  var valid_589026 = query.getOrDefault("oauth_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "oauth_token", valid_589026
  var valid_589027 = query.getOrDefault("callback")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "callback", valid_589027
  var valid_589028 = query.getOrDefault("access_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "access_token", valid_589028
  var valid_589029 = query.getOrDefault("uploadType")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "uploadType", valid_589029
  var valid_589030 = query.getOrDefault("parent")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "parent", valid_589030
  var valid_589031 = query.getOrDefault("key")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "key", valid_589031
  var valid_589032 = query.getOrDefault("$.xgafv")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("1"))
  if valid_589032 != nil:
    section.add "$.xgafv", valid_589032
  var valid_589033 = query.getOrDefault("prettyPrint")
  valid_589033 = validateParameter(valid_589033, JBool, required = false,
                                 default = newJBool(true))
  if valid_589033 != nil:
    section.add "prettyPrint", valid_589033
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

proc call*(call_589035: Call_CloudresourcemanagerFoldersCreate_589019;
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
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_CloudresourcemanagerFoldersCreate_589019;
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
  var query_589037 = newJObject()
  var body_589038 = newJObject()
  add(query_589037, "upload_protocol", newJString(uploadProtocol))
  add(query_589037, "fields", newJString(fields))
  add(query_589037, "quotaUser", newJString(quotaUser))
  add(query_589037, "alt", newJString(alt))
  add(query_589037, "oauth_token", newJString(oauthToken))
  add(query_589037, "callback", newJString(callback))
  add(query_589037, "access_token", newJString(accessToken))
  add(query_589037, "uploadType", newJString(uploadType))
  add(query_589037, "parent", newJString(parent))
  add(query_589037, "key", newJString(key))
  add(query_589037, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589038 = body
  add(query_589037, "prettyPrint", newJBool(prettyPrint))
  result = call_589036.call(nil, query_589037, nil, nil, body_589038)

var cloudresourcemanagerFoldersCreate* = Call_CloudresourcemanagerFoldersCreate_589019(
    name: "cloudresourcemanagerFoldersCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders",
    validator: validate_CloudresourcemanagerFoldersCreate_589020, base: "/",
    url: url_CloudresourcemanagerFoldersCreate_589021, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersList_588998 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersList_589000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersList_588999(path: JsonNode;
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
  var valid_589001 = query.getOrDefault("upload_protocol")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "upload_protocol", valid_589001
  var valid_589002 = query.getOrDefault("fields")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "fields", valid_589002
  var valid_589003 = query.getOrDefault("pageToken")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "pageToken", valid_589003
  var valid_589004 = query.getOrDefault("quotaUser")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "quotaUser", valid_589004
  var valid_589005 = query.getOrDefault("alt")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("json"))
  if valid_589005 != nil:
    section.add "alt", valid_589005
  var valid_589006 = query.getOrDefault("oauth_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "oauth_token", valid_589006
  var valid_589007 = query.getOrDefault("callback")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "callback", valid_589007
  var valid_589008 = query.getOrDefault("access_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "access_token", valid_589008
  var valid_589009 = query.getOrDefault("uploadType")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "uploadType", valid_589009
  var valid_589010 = query.getOrDefault("parent")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "parent", valid_589010
  var valid_589011 = query.getOrDefault("showDeleted")
  valid_589011 = validateParameter(valid_589011, JBool, required = false, default = nil)
  if valid_589011 != nil:
    section.add "showDeleted", valid_589011
  var valid_589012 = query.getOrDefault("key")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "key", valid_589012
  var valid_589013 = query.getOrDefault("$.xgafv")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = newJString("1"))
  if valid_589013 != nil:
    section.add "$.xgafv", valid_589013
  var valid_589014 = query.getOrDefault("pageSize")
  valid_589014 = validateParameter(valid_589014, JInt, required = false, default = nil)
  if valid_589014 != nil:
    section.add "pageSize", valid_589014
  var valid_589015 = query.getOrDefault("prettyPrint")
  valid_589015 = validateParameter(valid_589015, JBool, required = false,
                                 default = newJBool(true))
  if valid_589015 != nil:
    section.add "prettyPrint", valid_589015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589016: Call_CloudresourcemanagerFoldersList_588998;
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
  let valid = call_589016.validator(path, query, header, formData, body)
  let scheme = call_589016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589016.url(scheme.get, call_589016.host, call_589016.base,
                         call_589016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589016, url, valid)

proc call*(call_589017: Call_CloudresourcemanagerFoldersList_588998;
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
  var query_589018 = newJObject()
  add(query_589018, "upload_protocol", newJString(uploadProtocol))
  add(query_589018, "fields", newJString(fields))
  add(query_589018, "pageToken", newJString(pageToken))
  add(query_589018, "quotaUser", newJString(quotaUser))
  add(query_589018, "alt", newJString(alt))
  add(query_589018, "oauth_token", newJString(oauthToken))
  add(query_589018, "callback", newJString(callback))
  add(query_589018, "access_token", newJString(accessToken))
  add(query_589018, "uploadType", newJString(uploadType))
  add(query_589018, "parent", newJString(parent))
  add(query_589018, "showDeleted", newJBool(showDeleted))
  add(query_589018, "key", newJString(key))
  add(query_589018, "$.xgafv", newJString(Xgafv))
  add(query_589018, "pageSize", newJInt(pageSize))
  add(query_589018, "prettyPrint", newJBool(prettyPrint))
  result = call_589017.call(nil, query_589018, nil, nil, nil)

var cloudresourcemanagerFoldersList* = Call_CloudresourcemanagerFoldersList_588998(
    name: "cloudresourcemanagerFoldersList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders",
    validator: validate_CloudresourcemanagerFoldersList_588999, base: "/",
    url: url_CloudresourcemanagerFoldersList_589000, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersSearch_589039 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersSearch_589041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersSearch_589040(path: JsonNode;
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
  var valid_589042 = query.getOrDefault("upload_protocol")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "upload_protocol", valid_589042
  var valid_589043 = query.getOrDefault("fields")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "fields", valid_589043
  var valid_589044 = query.getOrDefault("quotaUser")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "quotaUser", valid_589044
  var valid_589045 = query.getOrDefault("alt")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = newJString("json"))
  if valid_589045 != nil:
    section.add "alt", valid_589045
  var valid_589046 = query.getOrDefault("oauth_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "oauth_token", valid_589046
  var valid_589047 = query.getOrDefault("callback")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "callback", valid_589047
  var valid_589048 = query.getOrDefault("access_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "access_token", valid_589048
  var valid_589049 = query.getOrDefault("uploadType")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "uploadType", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  var valid_589051 = query.getOrDefault("$.xgafv")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = newJString("1"))
  if valid_589051 != nil:
    section.add "$.xgafv", valid_589051
  var valid_589052 = query.getOrDefault("prettyPrint")
  valid_589052 = validateParameter(valid_589052, JBool, required = false,
                                 default = newJBool(true))
  if valid_589052 != nil:
    section.add "prettyPrint", valid_589052
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

proc call*(call_589054: Call_CloudresourcemanagerFoldersSearch_589039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search for folders that match specific filter criteria.
  ## Search provides an eventually consistent view of the folders a user has
  ## access to which meet the specified filter criteria.
  ## 
  ## This will only return folders on which the caller has the
  ## permission `resourcemanager.folders.get`.
  ## 
  let valid = call_589054.validator(path, query, header, formData, body)
  let scheme = call_589054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589054.url(scheme.get, call_589054.host, call_589054.base,
                         call_589054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589054, url, valid)

proc call*(call_589055: Call_CloudresourcemanagerFoldersSearch_589039;
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
  var query_589056 = newJObject()
  var body_589057 = newJObject()
  add(query_589056, "upload_protocol", newJString(uploadProtocol))
  add(query_589056, "fields", newJString(fields))
  add(query_589056, "quotaUser", newJString(quotaUser))
  add(query_589056, "alt", newJString(alt))
  add(query_589056, "oauth_token", newJString(oauthToken))
  add(query_589056, "callback", newJString(callback))
  add(query_589056, "access_token", newJString(accessToken))
  add(query_589056, "uploadType", newJString(uploadType))
  add(query_589056, "key", newJString(key))
  add(query_589056, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589057 = body
  add(query_589056, "prettyPrint", newJBool(prettyPrint))
  result = call_589055.call(nil, query_589056, nil, nil, body_589057)

var cloudresourcemanagerFoldersSearch* = Call_CloudresourcemanagerFoldersSearch_589039(
    name: "cloudresourcemanagerFoldersSearch", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders:search",
    validator: validate_CloudresourcemanagerFoldersSearch_589040, base: "/",
    url: url_CloudresourcemanagerFoldersSearch_589041, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersGet_589058 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersGet_589060(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerFoldersGet_589059(path: JsonNode;
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
  var valid_589061 = path.getOrDefault("name")
  valid_589061 = validateParameter(valid_589061, JString, required = true,
                                 default = nil)
  if valid_589061 != nil:
    section.add "name", valid_589061
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
  var valid_589062 = query.getOrDefault("upload_protocol")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "upload_protocol", valid_589062
  var valid_589063 = query.getOrDefault("fields")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "fields", valid_589063
  var valid_589064 = query.getOrDefault("quotaUser")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "quotaUser", valid_589064
  var valid_589065 = query.getOrDefault("alt")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("json"))
  if valid_589065 != nil:
    section.add "alt", valid_589065
  var valid_589066 = query.getOrDefault("oauth_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "oauth_token", valid_589066
  var valid_589067 = query.getOrDefault("callback")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "callback", valid_589067
  var valid_589068 = query.getOrDefault("access_token")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "access_token", valid_589068
  var valid_589069 = query.getOrDefault("uploadType")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "uploadType", valid_589069
  var valid_589070 = query.getOrDefault("key")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "key", valid_589070
  var valid_589071 = query.getOrDefault("$.xgafv")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = newJString("1"))
  if valid_589071 != nil:
    section.add "$.xgafv", valid_589071
  var valid_589072 = query.getOrDefault("prettyPrint")
  valid_589072 = validateParameter(valid_589072, JBool, required = false,
                                 default = newJBool(true))
  if valid_589072 != nil:
    section.add "prettyPrint", valid_589072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589073: Call_CloudresourcemanagerFoldersGet_589058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Folder identified by the supplied resource name.
  ## Valid Folder resource names have the format `folders/{folder_id}`
  ## (for example, `folders/1234`).
  ## The caller must have `resourcemanager.folders.get` permission on the
  ## identified folder.
  ## 
  let valid = call_589073.validator(path, query, header, formData, body)
  let scheme = call_589073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589073.url(scheme.get, call_589073.host, call_589073.base,
                         call_589073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589073, url, valid)

proc call*(call_589074: Call_CloudresourcemanagerFoldersGet_589058; name: string;
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
  var path_589075 = newJObject()
  var query_589076 = newJObject()
  add(query_589076, "upload_protocol", newJString(uploadProtocol))
  add(query_589076, "fields", newJString(fields))
  add(query_589076, "quotaUser", newJString(quotaUser))
  add(path_589075, "name", newJString(name))
  add(query_589076, "alt", newJString(alt))
  add(query_589076, "oauth_token", newJString(oauthToken))
  add(query_589076, "callback", newJString(callback))
  add(query_589076, "access_token", newJString(accessToken))
  add(query_589076, "uploadType", newJString(uploadType))
  add(query_589076, "key", newJString(key))
  add(query_589076, "$.xgafv", newJString(Xgafv))
  add(query_589076, "prettyPrint", newJBool(prettyPrint))
  result = call_589074.call(path_589075, query_589076, nil, nil, nil)

var cloudresourcemanagerFoldersGet* = Call_CloudresourcemanagerFoldersGet_589058(
    name: "cloudresourcemanagerFoldersGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersGet_589059, base: "/",
    url: url_CloudresourcemanagerFoldersGet_589060, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersPatch_589096 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersPatch_589098(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerFoldersPatch_589097(path: JsonNode;
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
  var valid_589099 = path.getOrDefault("name")
  valid_589099 = validateParameter(valid_589099, JString, required = true,
                                 default = nil)
  if valid_589099 != nil:
    section.add "name", valid_589099
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
  var valid_589100 = query.getOrDefault("upload_protocol")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "upload_protocol", valid_589100
  var valid_589101 = query.getOrDefault("fields")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "fields", valid_589101
  var valid_589102 = query.getOrDefault("quotaUser")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "quotaUser", valid_589102
  var valid_589103 = query.getOrDefault("alt")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = newJString("json"))
  if valid_589103 != nil:
    section.add "alt", valid_589103
  var valid_589104 = query.getOrDefault("oauth_token")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "oauth_token", valid_589104
  var valid_589105 = query.getOrDefault("callback")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "callback", valid_589105
  var valid_589106 = query.getOrDefault("access_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "access_token", valid_589106
  var valid_589107 = query.getOrDefault("uploadType")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "uploadType", valid_589107
  var valid_589108 = query.getOrDefault("key")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "key", valid_589108
  var valid_589109 = query.getOrDefault("$.xgafv")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = newJString("1"))
  if valid_589109 != nil:
    section.add "$.xgafv", valid_589109
  var valid_589110 = query.getOrDefault("prettyPrint")
  valid_589110 = validateParameter(valid_589110, JBool, required = false,
                                 default = newJBool(true))
  if valid_589110 != nil:
    section.add "prettyPrint", valid_589110
  var valid_589111 = query.getOrDefault("updateMask")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "updateMask", valid_589111
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

proc call*(call_589113: Call_CloudresourcemanagerFoldersPatch_589096;
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
  let valid = call_589113.validator(path, query, header, formData, body)
  let scheme = call_589113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589113.url(scheme.get, call_589113.host, call_589113.base,
                         call_589113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589113, url, valid)

proc call*(call_589114: Call_CloudresourcemanagerFoldersPatch_589096; name: string;
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
  var path_589115 = newJObject()
  var query_589116 = newJObject()
  var body_589117 = newJObject()
  add(query_589116, "upload_protocol", newJString(uploadProtocol))
  add(query_589116, "fields", newJString(fields))
  add(query_589116, "quotaUser", newJString(quotaUser))
  add(path_589115, "name", newJString(name))
  add(query_589116, "alt", newJString(alt))
  add(query_589116, "oauth_token", newJString(oauthToken))
  add(query_589116, "callback", newJString(callback))
  add(query_589116, "access_token", newJString(accessToken))
  add(query_589116, "uploadType", newJString(uploadType))
  add(query_589116, "key", newJString(key))
  add(query_589116, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589117 = body
  add(query_589116, "prettyPrint", newJBool(prettyPrint))
  add(query_589116, "updateMask", newJString(updateMask))
  result = call_589114.call(path_589115, query_589116, nil, nil, body_589117)

var cloudresourcemanagerFoldersPatch* = Call_CloudresourcemanagerFoldersPatch_589096(
    name: "cloudresourcemanagerFoldersPatch", meth: HttpMethod.HttpPatch,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersPatch_589097, base: "/",
    url: url_CloudresourcemanagerFoldersPatch_589098, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersDelete_589077 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersDelete_589079(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerFoldersDelete_589078(path: JsonNode;
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
  var valid_589080 = path.getOrDefault("name")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "name", valid_589080
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
  var valid_589081 = query.getOrDefault("upload_protocol")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "upload_protocol", valid_589081
  var valid_589082 = query.getOrDefault("fields")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "fields", valid_589082
  var valid_589083 = query.getOrDefault("quotaUser")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "quotaUser", valid_589083
  var valid_589084 = query.getOrDefault("alt")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = newJString("json"))
  if valid_589084 != nil:
    section.add "alt", valid_589084
  var valid_589085 = query.getOrDefault("oauth_token")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "oauth_token", valid_589085
  var valid_589086 = query.getOrDefault("callback")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "callback", valid_589086
  var valid_589087 = query.getOrDefault("access_token")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "access_token", valid_589087
  var valid_589088 = query.getOrDefault("uploadType")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "uploadType", valid_589088
  var valid_589089 = query.getOrDefault("key")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "key", valid_589089
  var valid_589090 = query.getOrDefault("$.xgafv")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("1"))
  if valid_589090 != nil:
    section.add "$.xgafv", valid_589090
  var valid_589091 = query.getOrDefault("prettyPrint")
  valid_589091 = validateParameter(valid_589091, JBool, required = false,
                                 default = newJBool(true))
  if valid_589091 != nil:
    section.add "prettyPrint", valid_589091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589092: Call_CloudresourcemanagerFoldersDelete_589077;
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
  let valid = call_589092.validator(path, query, header, formData, body)
  let scheme = call_589092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589092.url(scheme.get, call_589092.host, call_589092.base,
                         call_589092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589092, url, valid)

proc call*(call_589093: Call_CloudresourcemanagerFoldersDelete_589077;
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
  var path_589094 = newJObject()
  var query_589095 = newJObject()
  add(query_589095, "upload_protocol", newJString(uploadProtocol))
  add(query_589095, "fields", newJString(fields))
  add(query_589095, "quotaUser", newJString(quotaUser))
  add(path_589094, "name", newJString(name))
  add(query_589095, "alt", newJString(alt))
  add(query_589095, "oauth_token", newJString(oauthToken))
  add(query_589095, "callback", newJString(callback))
  add(query_589095, "access_token", newJString(accessToken))
  add(query_589095, "uploadType", newJString(uploadType))
  add(query_589095, "key", newJString(key))
  add(query_589095, "$.xgafv", newJString(Xgafv))
  add(query_589095, "prettyPrint", newJBool(prettyPrint))
  result = call_589093.call(path_589094, query_589095, nil, nil, nil)

var cloudresourcemanagerFoldersDelete* = Call_CloudresourcemanagerFoldersDelete_589077(
    name: "cloudresourcemanagerFoldersDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersDelete_589078, base: "/",
    url: url_CloudresourcemanagerFoldersDelete_589079, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersMove_589118 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersMove_589120(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerFoldersMove_589119(path: JsonNode;
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
  var valid_589121 = path.getOrDefault("name")
  valid_589121 = validateParameter(valid_589121, JString, required = true,
                                 default = nil)
  if valid_589121 != nil:
    section.add "name", valid_589121
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
  var valid_589122 = query.getOrDefault("upload_protocol")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "upload_protocol", valid_589122
  var valid_589123 = query.getOrDefault("fields")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "fields", valid_589123
  var valid_589124 = query.getOrDefault("quotaUser")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "quotaUser", valid_589124
  var valid_589125 = query.getOrDefault("alt")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = newJString("json"))
  if valid_589125 != nil:
    section.add "alt", valid_589125
  var valid_589126 = query.getOrDefault("oauth_token")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "oauth_token", valid_589126
  var valid_589127 = query.getOrDefault("callback")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "callback", valid_589127
  var valid_589128 = query.getOrDefault("access_token")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "access_token", valid_589128
  var valid_589129 = query.getOrDefault("uploadType")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "uploadType", valid_589129
  var valid_589130 = query.getOrDefault("key")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "key", valid_589130
  var valid_589131 = query.getOrDefault("$.xgafv")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("1"))
  if valid_589131 != nil:
    section.add "$.xgafv", valid_589131
  var valid_589132 = query.getOrDefault("prettyPrint")
  valid_589132 = validateParameter(valid_589132, JBool, required = false,
                                 default = newJBool(true))
  if valid_589132 != nil:
    section.add "prettyPrint", valid_589132
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

proc call*(call_589134: Call_CloudresourcemanagerFoldersMove_589118;
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
  let valid = call_589134.validator(path, query, header, formData, body)
  let scheme = call_589134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589134.url(scheme.get, call_589134.host, call_589134.base,
                         call_589134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589134, url, valid)

proc call*(call_589135: Call_CloudresourcemanagerFoldersMove_589118; name: string;
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
  var path_589136 = newJObject()
  var query_589137 = newJObject()
  var body_589138 = newJObject()
  add(query_589137, "upload_protocol", newJString(uploadProtocol))
  add(query_589137, "fields", newJString(fields))
  add(query_589137, "quotaUser", newJString(quotaUser))
  add(path_589136, "name", newJString(name))
  add(query_589137, "alt", newJString(alt))
  add(query_589137, "oauth_token", newJString(oauthToken))
  add(query_589137, "callback", newJString(callback))
  add(query_589137, "access_token", newJString(accessToken))
  add(query_589137, "uploadType", newJString(uploadType))
  add(query_589137, "key", newJString(key))
  add(query_589137, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589138 = body
  add(query_589137, "prettyPrint", newJBool(prettyPrint))
  result = call_589135.call(path_589136, query_589137, nil, nil, body_589138)

var cloudresourcemanagerFoldersMove* = Call_CloudresourcemanagerFoldersMove_589118(
    name: "cloudresourcemanagerFoldersMove", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}:move",
    validator: validate_CloudresourcemanagerFoldersMove_589119, base: "/",
    url: url_CloudresourcemanagerFoldersMove_589120, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersUndelete_589139 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersUndelete_589141(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerFoldersUndelete_589140(path: JsonNode;
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
  var valid_589142 = path.getOrDefault("name")
  valid_589142 = validateParameter(valid_589142, JString, required = true,
                                 default = nil)
  if valid_589142 != nil:
    section.add "name", valid_589142
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
  var valid_589143 = query.getOrDefault("upload_protocol")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "upload_protocol", valid_589143
  var valid_589144 = query.getOrDefault("fields")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "fields", valid_589144
  var valid_589145 = query.getOrDefault("quotaUser")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "quotaUser", valid_589145
  var valid_589146 = query.getOrDefault("alt")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("json"))
  if valid_589146 != nil:
    section.add "alt", valid_589146
  var valid_589147 = query.getOrDefault("oauth_token")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "oauth_token", valid_589147
  var valid_589148 = query.getOrDefault("callback")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "callback", valid_589148
  var valid_589149 = query.getOrDefault("access_token")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "access_token", valid_589149
  var valid_589150 = query.getOrDefault("uploadType")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "uploadType", valid_589150
  var valid_589151 = query.getOrDefault("key")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "key", valid_589151
  var valid_589152 = query.getOrDefault("$.xgafv")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = newJString("1"))
  if valid_589152 != nil:
    section.add "$.xgafv", valid_589152
  var valid_589153 = query.getOrDefault("prettyPrint")
  valid_589153 = validateParameter(valid_589153, JBool, required = false,
                                 default = newJBool(true))
  if valid_589153 != nil:
    section.add "prettyPrint", valid_589153
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

proc call*(call_589155: Call_CloudresourcemanagerFoldersUndelete_589139;
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
  let valid = call_589155.validator(path, query, header, formData, body)
  let scheme = call_589155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589155.url(scheme.get, call_589155.host, call_589155.base,
                         call_589155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589155, url, valid)

proc call*(call_589156: Call_CloudresourcemanagerFoldersUndelete_589139;
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
  var path_589157 = newJObject()
  var query_589158 = newJObject()
  var body_589159 = newJObject()
  add(query_589158, "upload_protocol", newJString(uploadProtocol))
  add(query_589158, "fields", newJString(fields))
  add(query_589158, "quotaUser", newJString(quotaUser))
  add(path_589157, "name", newJString(name))
  add(query_589158, "alt", newJString(alt))
  add(query_589158, "oauth_token", newJString(oauthToken))
  add(query_589158, "callback", newJString(callback))
  add(query_589158, "access_token", newJString(accessToken))
  add(query_589158, "uploadType", newJString(uploadType))
  add(query_589158, "key", newJString(key))
  add(query_589158, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589159 = body
  add(query_589158, "prettyPrint", newJBool(prettyPrint))
  result = call_589156.call(path_589157, query_589158, nil, nil, body_589159)

var cloudresourcemanagerFoldersUndelete* = Call_CloudresourcemanagerFoldersUndelete_589139(
    name: "cloudresourcemanagerFoldersUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}:undelete",
    validator: validate_CloudresourcemanagerFoldersUndelete_589140, base: "/",
    url: url_CloudresourcemanagerFoldersUndelete_589141, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersGetIamPolicy_589160 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersGetIamPolicy_589162(protocol: Scheme;
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

proc validate_CloudresourcemanagerFoldersGetIamPolicy_589161(path: JsonNode;
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
  var valid_589163 = path.getOrDefault("resource")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "resource", valid_589163
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
  var valid_589164 = query.getOrDefault("upload_protocol")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "upload_protocol", valid_589164
  var valid_589165 = query.getOrDefault("fields")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "fields", valid_589165
  var valid_589166 = query.getOrDefault("quotaUser")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "quotaUser", valid_589166
  var valid_589167 = query.getOrDefault("alt")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = newJString("json"))
  if valid_589167 != nil:
    section.add "alt", valid_589167
  var valid_589168 = query.getOrDefault("oauth_token")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "oauth_token", valid_589168
  var valid_589169 = query.getOrDefault("callback")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "callback", valid_589169
  var valid_589170 = query.getOrDefault("access_token")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "access_token", valid_589170
  var valid_589171 = query.getOrDefault("uploadType")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "uploadType", valid_589171
  var valid_589172 = query.getOrDefault("key")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "key", valid_589172
  var valid_589173 = query.getOrDefault("$.xgafv")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = newJString("1"))
  if valid_589173 != nil:
    section.add "$.xgafv", valid_589173
  var valid_589174 = query.getOrDefault("prettyPrint")
  valid_589174 = validateParameter(valid_589174, JBool, required = false,
                                 default = newJBool(true))
  if valid_589174 != nil:
    section.add "prettyPrint", valid_589174
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

proc call*(call_589176: Call_CloudresourcemanagerFoldersGetIamPolicy_589160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a Folder. The returned policy may be
  ## empty if no such policy or resource exists. The `resource` field should
  ## be the Folder's resource name, e.g. "folders/1234".
  ## The caller must have `resourcemanager.folders.getIamPolicy` permission
  ## on the identified folder.
  ## 
  let valid = call_589176.validator(path, query, header, formData, body)
  let scheme = call_589176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589176.url(scheme.get, call_589176.host, call_589176.base,
                         call_589176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589176, url, valid)

proc call*(call_589177: Call_CloudresourcemanagerFoldersGetIamPolicy_589160;
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
  var path_589178 = newJObject()
  var query_589179 = newJObject()
  var body_589180 = newJObject()
  add(query_589179, "upload_protocol", newJString(uploadProtocol))
  add(query_589179, "fields", newJString(fields))
  add(query_589179, "quotaUser", newJString(quotaUser))
  add(query_589179, "alt", newJString(alt))
  add(query_589179, "oauth_token", newJString(oauthToken))
  add(query_589179, "callback", newJString(callback))
  add(query_589179, "access_token", newJString(accessToken))
  add(query_589179, "uploadType", newJString(uploadType))
  add(query_589179, "key", newJString(key))
  add(query_589179, "$.xgafv", newJString(Xgafv))
  add(path_589178, "resource", newJString(resource))
  if body != nil:
    body_589180 = body
  add(query_589179, "prettyPrint", newJBool(prettyPrint))
  result = call_589177.call(path_589178, query_589179, nil, nil, body_589180)

var cloudresourcemanagerFoldersGetIamPolicy* = Call_CloudresourcemanagerFoldersGetIamPolicy_589160(
    name: "cloudresourcemanagerFoldersGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerFoldersGetIamPolicy_589161, base: "/",
    url: url_CloudresourcemanagerFoldersGetIamPolicy_589162,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersSetIamPolicy_589181 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersSetIamPolicy_589183(protocol: Scheme;
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

proc validate_CloudresourcemanagerFoldersSetIamPolicy_589182(path: JsonNode;
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
  var valid_589184 = path.getOrDefault("resource")
  valid_589184 = validateParameter(valid_589184, JString, required = true,
                                 default = nil)
  if valid_589184 != nil:
    section.add "resource", valid_589184
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
  var valid_589185 = query.getOrDefault("upload_protocol")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "upload_protocol", valid_589185
  var valid_589186 = query.getOrDefault("fields")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "fields", valid_589186
  var valid_589187 = query.getOrDefault("quotaUser")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "quotaUser", valid_589187
  var valid_589188 = query.getOrDefault("alt")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = newJString("json"))
  if valid_589188 != nil:
    section.add "alt", valid_589188
  var valid_589189 = query.getOrDefault("oauth_token")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "oauth_token", valid_589189
  var valid_589190 = query.getOrDefault("callback")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "callback", valid_589190
  var valid_589191 = query.getOrDefault("access_token")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "access_token", valid_589191
  var valid_589192 = query.getOrDefault("uploadType")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "uploadType", valid_589192
  var valid_589193 = query.getOrDefault("key")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "key", valid_589193
  var valid_589194 = query.getOrDefault("$.xgafv")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = newJString("1"))
  if valid_589194 != nil:
    section.add "$.xgafv", valid_589194
  var valid_589195 = query.getOrDefault("prettyPrint")
  valid_589195 = validateParameter(valid_589195, JBool, required = false,
                                 default = newJBool(true))
  if valid_589195 != nil:
    section.add "prettyPrint", valid_589195
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

proc call*(call_589197: Call_CloudresourcemanagerFoldersSetIamPolicy_589181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on a Folder, replacing any existing policy.
  ## The `resource` field should be the Folder's resource name, e.g.
  ## "folders/1234".
  ## The caller must have `resourcemanager.folders.setIamPolicy` permission
  ## on the identified folder.
  ## 
  let valid = call_589197.validator(path, query, header, formData, body)
  let scheme = call_589197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589197.url(scheme.get, call_589197.host, call_589197.base,
                         call_589197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589197, url, valid)

proc call*(call_589198: Call_CloudresourcemanagerFoldersSetIamPolicy_589181;
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
  var path_589199 = newJObject()
  var query_589200 = newJObject()
  var body_589201 = newJObject()
  add(query_589200, "upload_protocol", newJString(uploadProtocol))
  add(query_589200, "fields", newJString(fields))
  add(query_589200, "quotaUser", newJString(quotaUser))
  add(query_589200, "alt", newJString(alt))
  add(query_589200, "oauth_token", newJString(oauthToken))
  add(query_589200, "callback", newJString(callback))
  add(query_589200, "access_token", newJString(accessToken))
  add(query_589200, "uploadType", newJString(uploadType))
  add(query_589200, "key", newJString(key))
  add(query_589200, "$.xgafv", newJString(Xgafv))
  add(path_589199, "resource", newJString(resource))
  if body != nil:
    body_589201 = body
  add(query_589200, "prettyPrint", newJBool(prettyPrint))
  result = call_589198.call(path_589199, query_589200, nil, nil, body_589201)

var cloudresourcemanagerFoldersSetIamPolicy* = Call_CloudresourcemanagerFoldersSetIamPolicy_589181(
    name: "cloudresourcemanagerFoldersSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerFoldersSetIamPolicy_589182, base: "/",
    url: url_CloudresourcemanagerFoldersSetIamPolicy_589183,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersTestIamPermissions_589202 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerFoldersTestIamPermissions_589204(protocol: Scheme;
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

proc validate_CloudresourcemanagerFoldersTestIamPermissions_589203(
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
  var valid_589205 = path.getOrDefault("resource")
  valid_589205 = validateParameter(valid_589205, JString, required = true,
                                 default = nil)
  if valid_589205 != nil:
    section.add "resource", valid_589205
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
  var valid_589206 = query.getOrDefault("upload_protocol")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "upload_protocol", valid_589206
  var valid_589207 = query.getOrDefault("fields")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "fields", valid_589207
  var valid_589208 = query.getOrDefault("quotaUser")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "quotaUser", valid_589208
  var valid_589209 = query.getOrDefault("alt")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("json"))
  if valid_589209 != nil:
    section.add "alt", valid_589209
  var valid_589210 = query.getOrDefault("oauth_token")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "oauth_token", valid_589210
  var valid_589211 = query.getOrDefault("callback")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "callback", valid_589211
  var valid_589212 = query.getOrDefault("access_token")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "access_token", valid_589212
  var valid_589213 = query.getOrDefault("uploadType")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "uploadType", valid_589213
  var valid_589214 = query.getOrDefault("key")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "key", valid_589214
  var valid_589215 = query.getOrDefault("$.xgafv")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = newJString("1"))
  if valid_589215 != nil:
    section.add "$.xgafv", valid_589215
  var valid_589216 = query.getOrDefault("prettyPrint")
  valid_589216 = validateParameter(valid_589216, JBool, required = false,
                                 default = newJBool(true))
  if valid_589216 != nil:
    section.add "prettyPrint", valid_589216
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

proc call*(call_589218: Call_CloudresourcemanagerFoldersTestIamPermissions_589202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Folder.
  ## The `resource` field should be the Folder's resource name,
  ## e.g. "folders/1234".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_589218.validator(path, query, header, formData, body)
  let scheme = call_589218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589218.url(scheme.get, call_589218.host, call_589218.base,
                         call_589218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589218, url, valid)

proc call*(call_589219: Call_CloudresourcemanagerFoldersTestIamPermissions_589202;
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
  var path_589220 = newJObject()
  var query_589221 = newJObject()
  var body_589222 = newJObject()
  add(query_589221, "upload_protocol", newJString(uploadProtocol))
  add(query_589221, "fields", newJString(fields))
  add(query_589221, "quotaUser", newJString(quotaUser))
  add(query_589221, "alt", newJString(alt))
  add(query_589221, "oauth_token", newJString(oauthToken))
  add(query_589221, "callback", newJString(callback))
  add(query_589221, "access_token", newJString(accessToken))
  add(query_589221, "uploadType", newJString(uploadType))
  add(query_589221, "key", newJString(key))
  add(query_589221, "$.xgafv", newJString(Xgafv))
  add(path_589220, "resource", newJString(resource))
  if body != nil:
    body_589222 = body
  add(query_589221, "prettyPrint", newJBool(prettyPrint))
  result = call_589219.call(path_589220, query_589221, nil, nil, body_589222)

var cloudresourcemanagerFoldersTestIamPermissions* = Call_CloudresourcemanagerFoldersTestIamPermissions_589202(
    name: "cloudresourcemanagerFoldersTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerFoldersTestIamPermissions_589203,
    base: "/", url: url_CloudresourcemanagerFoldersTestIamPermissions_589204,
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
