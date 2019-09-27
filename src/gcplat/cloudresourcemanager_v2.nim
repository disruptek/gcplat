
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Resource Manager
## version: v2
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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudresourcemanagerOperationsGet_597677 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerOperationsGet_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOperationsGet_597678(path: JsonNode;
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
  var valid_597805 = path.getOrDefault("name")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "name", valid_597805
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
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("callback")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "callback", valid_597824
  var valid_597825 = query.getOrDefault("access_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "access_token", valid_597825
  var valid_597826 = query.getOrDefault("uploadType")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "uploadType", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597852: Call_CloudresourcemanagerOperationsGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_597852.validator(path, query, header, formData, body)
  let scheme = call_597852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597852.url(scheme.get, call_597852.host, call_597852.base,
                         call_597852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597852, url, valid)

proc call*(call_597923: Call_CloudresourcemanagerOperationsGet_597677;
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
  var path_597924 = newJObject()
  var query_597926 = newJObject()
  add(query_597926, "upload_protocol", newJString(uploadProtocol))
  add(query_597926, "fields", newJString(fields))
  add(query_597926, "quotaUser", newJString(quotaUser))
  add(path_597924, "name", newJString(name))
  add(query_597926, "alt", newJString(alt))
  add(query_597926, "oauth_token", newJString(oauthToken))
  add(query_597926, "callback", newJString(callback))
  add(query_597926, "access_token", newJString(accessToken))
  add(query_597926, "uploadType", newJString(uploadType))
  add(query_597926, "key", newJString(key))
  add(query_597926, "$.xgafv", newJString(Xgafv))
  add(query_597926, "prettyPrint", newJBool(prettyPrint))
  result = call_597923.call(path_597924, query_597926, nil, nil, nil)

var cloudresourcemanagerOperationsGet* = Call_CloudresourcemanagerOperationsGet_597677(
    name: "cloudresourcemanagerOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerOperationsGet_597678, base: "/",
    url: url_CloudresourcemanagerOperationsGet_597679, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersCreate_597986 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersCreate_597988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersCreate_597987(path: JsonNode;
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
  var valid_597989 = query.getOrDefault("upload_protocol")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "upload_protocol", valid_597989
  var valid_597990 = query.getOrDefault("fields")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "fields", valid_597990
  var valid_597991 = query.getOrDefault("quotaUser")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "quotaUser", valid_597991
  var valid_597992 = query.getOrDefault("alt")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = newJString("json"))
  if valid_597992 != nil:
    section.add "alt", valid_597992
  var valid_597993 = query.getOrDefault("oauth_token")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "oauth_token", valid_597993
  var valid_597994 = query.getOrDefault("callback")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "callback", valid_597994
  var valid_597995 = query.getOrDefault("access_token")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "access_token", valid_597995
  var valid_597996 = query.getOrDefault("uploadType")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "uploadType", valid_597996
  var valid_597997 = query.getOrDefault("parent")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "parent", valid_597997
  var valid_597998 = query.getOrDefault("key")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "key", valid_597998
  var valid_597999 = query.getOrDefault("$.xgafv")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = newJString("1"))
  if valid_597999 != nil:
    section.add "$.xgafv", valid_597999
  var valid_598000 = query.getOrDefault("prettyPrint")
  valid_598000 = validateParameter(valid_598000, JBool, required = false,
                                 default = newJBool(true))
  if valid_598000 != nil:
    section.add "prettyPrint", valid_598000
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

proc call*(call_598002: Call_CloudresourcemanagerFoldersCreate_597986;
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
  let valid = call_598002.validator(path, query, header, formData, body)
  let scheme = call_598002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598002.url(scheme.get, call_598002.host, call_598002.base,
                         call_598002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598002, url, valid)

proc call*(call_598003: Call_CloudresourcemanagerFoldersCreate_597986;
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
  var query_598004 = newJObject()
  var body_598005 = newJObject()
  add(query_598004, "upload_protocol", newJString(uploadProtocol))
  add(query_598004, "fields", newJString(fields))
  add(query_598004, "quotaUser", newJString(quotaUser))
  add(query_598004, "alt", newJString(alt))
  add(query_598004, "oauth_token", newJString(oauthToken))
  add(query_598004, "callback", newJString(callback))
  add(query_598004, "access_token", newJString(accessToken))
  add(query_598004, "uploadType", newJString(uploadType))
  add(query_598004, "parent", newJString(parent))
  add(query_598004, "key", newJString(key))
  add(query_598004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598005 = body
  add(query_598004, "prettyPrint", newJBool(prettyPrint))
  result = call_598003.call(nil, query_598004, nil, nil, body_598005)

var cloudresourcemanagerFoldersCreate* = Call_CloudresourcemanagerFoldersCreate_597986(
    name: "cloudresourcemanagerFoldersCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders",
    validator: validate_CloudresourcemanagerFoldersCreate_597987, base: "/",
    url: url_CloudresourcemanagerFoldersCreate_597988, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersList_597965 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersList_597967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersList_597966(path: JsonNode;
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
  var valid_597968 = query.getOrDefault("upload_protocol")
  valid_597968 = validateParameter(valid_597968, JString, required = false,
                                 default = nil)
  if valid_597968 != nil:
    section.add "upload_protocol", valid_597968
  var valid_597969 = query.getOrDefault("fields")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "fields", valid_597969
  var valid_597970 = query.getOrDefault("pageToken")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "pageToken", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("alt")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = newJString("json"))
  if valid_597972 != nil:
    section.add "alt", valid_597972
  var valid_597973 = query.getOrDefault("oauth_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "oauth_token", valid_597973
  var valid_597974 = query.getOrDefault("callback")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "callback", valid_597974
  var valid_597975 = query.getOrDefault("access_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "access_token", valid_597975
  var valid_597976 = query.getOrDefault("uploadType")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "uploadType", valid_597976
  var valid_597977 = query.getOrDefault("parent")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "parent", valid_597977
  var valid_597978 = query.getOrDefault("showDeleted")
  valid_597978 = validateParameter(valid_597978, JBool, required = false, default = nil)
  if valid_597978 != nil:
    section.add "showDeleted", valid_597978
  var valid_597979 = query.getOrDefault("key")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "key", valid_597979
  var valid_597980 = query.getOrDefault("$.xgafv")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = newJString("1"))
  if valid_597980 != nil:
    section.add "$.xgafv", valid_597980
  var valid_597981 = query.getOrDefault("pageSize")
  valid_597981 = validateParameter(valid_597981, JInt, required = false, default = nil)
  if valid_597981 != nil:
    section.add "pageSize", valid_597981
  var valid_597982 = query.getOrDefault("prettyPrint")
  valid_597982 = validateParameter(valid_597982, JBool, required = false,
                                 default = newJBool(true))
  if valid_597982 != nil:
    section.add "prettyPrint", valid_597982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597983: Call_CloudresourcemanagerFoldersList_597965;
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
  let valid = call_597983.validator(path, query, header, formData, body)
  let scheme = call_597983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597983.url(scheme.get, call_597983.host, call_597983.base,
                         call_597983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597983, url, valid)

proc call*(call_597984: Call_CloudresourcemanagerFoldersList_597965;
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
  var query_597985 = newJObject()
  add(query_597985, "upload_protocol", newJString(uploadProtocol))
  add(query_597985, "fields", newJString(fields))
  add(query_597985, "pageToken", newJString(pageToken))
  add(query_597985, "quotaUser", newJString(quotaUser))
  add(query_597985, "alt", newJString(alt))
  add(query_597985, "oauth_token", newJString(oauthToken))
  add(query_597985, "callback", newJString(callback))
  add(query_597985, "access_token", newJString(accessToken))
  add(query_597985, "uploadType", newJString(uploadType))
  add(query_597985, "parent", newJString(parent))
  add(query_597985, "showDeleted", newJBool(showDeleted))
  add(query_597985, "key", newJString(key))
  add(query_597985, "$.xgafv", newJString(Xgafv))
  add(query_597985, "pageSize", newJInt(pageSize))
  add(query_597985, "prettyPrint", newJBool(prettyPrint))
  result = call_597984.call(nil, query_597985, nil, nil, nil)

var cloudresourcemanagerFoldersList* = Call_CloudresourcemanagerFoldersList_597965(
    name: "cloudresourcemanagerFoldersList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders",
    validator: validate_CloudresourcemanagerFoldersList_597966, base: "/",
    url: url_CloudresourcemanagerFoldersList_597967, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersSearch_598006 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersSearch_598008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerFoldersSearch_598007(path: JsonNode;
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
  var valid_598009 = query.getOrDefault("upload_protocol")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "upload_protocol", valid_598009
  var valid_598010 = query.getOrDefault("fields")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "fields", valid_598010
  var valid_598011 = query.getOrDefault("quotaUser")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "quotaUser", valid_598011
  var valid_598012 = query.getOrDefault("alt")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = newJString("json"))
  if valid_598012 != nil:
    section.add "alt", valid_598012
  var valid_598013 = query.getOrDefault("oauth_token")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "oauth_token", valid_598013
  var valid_598014 = query.getOrDefault("callback")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "callback", valid_598014
  var valid_598015 = query.getOrDefault("access_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "access_token", valid_598015
  var valid_598016 = query.getOrDefault("uploadType")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "uploadType", valid_598016
  var valid_598017 = query.getOrDefault("key")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "key", valid_598017
  var valid_598018 = query.getOrDefault("$.xgafv")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = newJString("1"))
  if valid_598018 != nil:
    section.add "$.xgafv", valid_598018
  var valid_598019 = query.getOrDefault("prettyPrint")
  valid_598019 = validateParameter(valid_598019, JBool, required = false,
                                 default = newJBool(true))
  if valid_598019 != nil:
    section.add "prettyPrint", valid_598019
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

proc call*(call_598021: Call_CloudresourcemanagerFoldersSearch_598006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search for folders that match specific filter criteria.
  ## Search provides an eventually consistent view of the folders a user has
  ## access to which meet the specified filter criteria.
  ## 
  ## This will only return folders on which the caller has the
  ## permission `resourcemanager.folders.get`.
  ## 
  let valid = call_598021.validator(path, query, header, formData, body)
  let scheme = call_598021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598021.url(scheme.get, call_598021.host, call_598021.base,
                         call_598021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598021, url, valid)

proc call*(call_598022: Call_CloudresourcemanagerFoldersSearch_598006;
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
  var query_598023 = newJObject()
  var body_598024 = newJObject()
  add(query_598023, "upload_protocol", newJString(uploadProtocol))
  add(query_598023, "fields", newJString(fields))
  add(query_598023, "quotaUser", newJString(quotaUser))
  add(query_598023, "alt", newJString(alt))
  add(query_598023, "oauth_token", newJString(oauthToken))
  add(query_598023, "callback", newJString(callback))
  add(query_598023, "access_token", newJString(accessToken))
  add(query_598023, "uploadType", newJString(uploadType))
  add(query_598023, "key", newJString(key))
  add(query_598023, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598024 = body
  add(query_598023, "prettyPrint", newJBool(prettyPrint))
  result = call_598022.call(nil, query_598023, nil, nil, body_598024)

var cloudresourcemanagerFoldersSearch* = Call_CloudresourcemanagerFoldersSearch_598006(
    name: "cloudresourcemanagerFoldersSearch", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/folders:search",
    validator: validate_CloudresourcemanagerFoldersSearch_598007, base: "/",
    url: url_CloudresourcemanagerFoldersSearch_598008, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersGet_598025 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersGet_598027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersGet_598026(path: JsonNode;
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
  var valid_598028 = path.getOrDefault("name")
  valid_598028 = validateParameter(valid_598028, JString, required = true,
                                 default = nil)
  if valid_598028 != nil:
    section.add "name", valid_598028
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
  var valid_598029 = query.getOrDefault("upload_protocol")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "upload_protocol", valid_598029
  var valid_598030 = query.getOrDefault("fields")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "fields", valid_598030
  var valid_598031 = query.getOrDefault("quotaUser")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "quotaUser", valid_598031
  var valid_598032 = query.getOrDefault("alt")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = newJString("json"))
  if valid_598032 != nil:
    section.add "alt", valid_598032
  var valid_598033 = query.getOrDefault("oauth_token")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "oauth_token", valid_598033
  var valid_598034 = query.getOrDefault("callback")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "callback", valid_598034
  var valid_598035 = query.getOrDefault("access_token")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "access_token", valid_598035
  var valid_598036 = query.getOrDefault("uploadType")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "uploadType", valid_598036
  var valid_598037 = query.getOrDefault("key")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "key", valid_598037
  var valid_598038 = query.getOrDefault("$.xgafv")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = newJString("1"))
  if valid_598038 != nil:
    section.add "$.xgafv", valid_598038
  var valid_598039 = query.getOrDefault("prettyPrint")
  valid_598039 = validateParameter(valid_598039, JBool, required = false,
                                 default = newJBool(true))
  if valid_598039 != nil:
    section.add "prettyPrint", valid_598039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598040: Call_CloudresourcemanagerFoldersGet_598025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Folder identified by the supplied resource name.
  ## Valid Folder resource names have the format `folders/{folder_id}`
  ## (for example, `folders/1234`).
  ## The caller must have `resourcemanager.folders.get` permission on the
  ## identified folder.
  ## 
  let valid = call_598040.validator(path, query, header, formData, body)
  let scheme = call_598040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598040.url(scheme.get, call_598040.host, call_598040.base,
                         call_598040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598040, url, valid)

proc call*(call_598041: Call_CloudresourcemanagerFoldersGet_598025; name: string;
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
  var path_598042 = newJObject()
  var query_598043 = newJObject()
  add(query_598043, "upload_protocol", newJString(uploadProtocol))
  add(query_598043, "fields", newJString(fields))
  add(query_598043, "quotaUser", newJString(quotaUser))
  add(path_598042, "name", newJString(name))
  add(query_598043, "alt", newJString(alt))
  add(query_598043, "oauth_token", newJString(oauthToken))
  add(query_598043, "callback", newJString(callback))
  add(query_598043, "access_token", newJString(accessToken))
  add(query_598043, "uploadType", newJString(uploadType))
  add(query_598043, "key", newJString(key))
  add(query_598043, "$.xgafv", newJString(Xgafv))
  add(query_598043, "prettyPrint", newJBool(prettyPrint))
  result = call_598041.call(path_598042, query_598043, nil, nil, nil)

var cloudresourcemanagerFoldersGet* = Call_CloudresourcemanagerFoldersGet_598025(
    name: "cloudresourcemanagerFoldersGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersGet_598026, base: "/",
    url: url_CloudresourcemanagerFoldersGet_598027, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersPatch_598063 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersPatch_598065(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersPatch_598064(path: JsonNode;
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
  var valid_598066 = path.getOrDefault("name")
  valid_598066 = validateParameter(valid_598066, JString, required = true,
                                 default = nil)
  if valid_598066 != nil:
    section.add "name", valid_598066
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
  var valid_598067 = query.getOrDefault("upload_protocol")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "upload_protocol", valid_598067
  var valid_598068 = query.getOrDefault("fields")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "fields", valid_598068
  var valid_598069 = query.getOrDefault("quotaUser")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "quotaUser", valid_598069
  var valid_598070 = query.getOrDefault("alt")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = newJString("json"))
  if valid_598070 != nil:
    section.add "alt", valid_598070
  var valid_598071 = query.getOrDefault("oauth_token")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "oauth_token", valid_598071
  var valid_598072 = query.getOrDefault("callback")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "callback", valid_598072
  var valid_598073 = query.getOrDefault("access_token")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "access_token", valid_598073
  var valid_598074 = query.getOrDefault("uploadType")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "uploadType", valid_598074
  var valid_598075 = query.getOrDefault("key")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "key", valid_598075
  var valid_598076 = query.getOrDefault("$.xgafv")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = newJString("1"))
  if valid_598076 != nil:
    section.add "$.xgafv", valid_598076
  var valid_598077 = query.getOrDefault("prettyPrint")
  valid_598077 = validateParameter(valid_598077, JBool, required = false,
                                 default = newJBool(true))
  if valid_598077 != nil:
    section.add "prettyPrint", valid_598077
  var valid_598078 = query.getOrDefault("updateMask")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "updateMask", valid_598078
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

proc call*(call_598080: Call_CloudresourcemanagerFoldersPatch_598063;
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
  let valid = call_598080.validator(path, query, header, formData, body)
  let scheme = call_598080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598080.url(scheme.get, call_598080.host, call_598080.base,
                         call_598080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598080, url, valid)

proc call*(call_598081: Call_CloudresourcemanagerFoldersPatch_598063; name: string;
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
  var path_598082 = newJObject()
  var query_598083 = newJObject()
  var body_598084 = newJObject()
  add(query_598083, "upload_protocol", newJString(uploadProtocol))
  add(query_598083, "fields", newJString(fields))
  add(query_598083, "quotaUser", newJString(quotaUser))
  add(path_598082, "name", newJString(name))
  add(query_598083, "alt", newJString(alt))
  add(query_598083, "oauth_token", newJString(oauthToken))
  add(query_598083, "callback", newJString(callback))
  add(query_598083, "access_token", newJString(accessToken))
  add(query_598083, "uploadType", newJString(uploadType))
  add(query_598083, "key", newJString(key))
  add(query_598083, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598084 = body
  add(query_598083, "prettyPrint", newJBool(prettyPrint))
  add(query_598083, "updateMask", newJString(updateMask))
  result = call_598081.call(path_598082, query_598083, nil, nil, body_598084)

var cloudresourcemanagerFoldersPatch* = Call_CloudresourcemanagerFoldersPatch_598063(
    name: "cloudresourcemanagerFoldersPatch", meth: HttpMethod.HttpPatch,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersPatch_598064, base: "/",
    url: url_CloudresourcemanagerFoldersPatch_598065, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersDelete_598044 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersDelete_598046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerFoldersDelete_598045(path: JsonNode;
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
  var valid_598047 = path.getOrDefault("name")
  valid_598047 = validateParameter(valid_598047, JString, required = true,
                                 default = nil)
  if valid_598047 != nil:
    section.add "name", valid_598047
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
  var valid_598048 = query.getOrDefault("upload_protocol")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "upload_protocol", valid_598048
  var valid_598049 = query.getOrDefault("fields")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "fields", valid_598049
  var valid_598050 = query.getOrDefault("quotaUser")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "quotaUser", valid_598050
  var valid_598051 = query.getOrDefault("alt")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = newJString("json"))
  if valid_598051 != nil:
    section.add "alt", valid_598051
  var valid_598052 = query.getOrDefault("oauth_token")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "oauth_token", valid_598052
  var valid_598053 = query.getOrDefault("callback")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "callback", valid_598053
  var valid_598054 = query.getOrDefault("access_token")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "access_token", valid_598054
  var valid_598055 = query.getOrDefault("uploadType")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "uploadType", valid_598055
  var valid_598056 = query.getOrDefault("key")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "key", valid_598056
  var valid_598057 = query.getOrDefault("$.xgafv")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = newJString("1"))
  if valid_598057 != nil:
    section.add "$.xgafv", valid_598057
  var valid_598058 = query.getOrDefault("prettyPrint")
  valid_598058 = validateParameter(valid_598058, JBool, required = false,
                                 default = newJBool(true))
  if valid_598058 != nil:
    section.add "prettyPrint", valid_598058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598059: Call_CloudresourcemanagerFoldersDelete_598044;
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
  let valid = call_598059.validator(path, query, header, formData, body)
  let scheme = call_598059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598059.url(scheme.get, call_598059.host, call_598059.base,
                         call_598059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598059, url, valid)

proc call*(call_598060: Call_CloudresourcemanagerFoldersDelete_598044;
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
  var path_598061 = newJObject()
  var query_598062 = newJObject()
  add(query_598062, "upload_protocol", newJString(uploadProtocol))
  add(query_598062, "fields", newJString(fields))
  add(query_598062, "quotaUser", newJString(quotaUser))
  add(path_598061, "name", newJString(name))
  add(query_598062, "alt", newJString(alt))
  add(query_598062, "oauth_token", newJString(oauthToken))
  add(query_598062, "callback", newJString(callback))
  add(query_598062, "access_token", newJString(accessToken))
  add(query_598062, "uploadType", newJString(uploadType))
  add(query_598062, "key", newJString(key))
  add(query_598062, "$.xgafv", newJString(Xgafv))
  add(query_598062, "prettyPrint", newJBool(prettyPrint))
  result = call_598060.call(path_598061, query_598062, nil, nil, nil)

var cloudresourcemanagerFoldersDelete* = Call_CloudresourcemanagerFoldersDelete_598044(
    name: "cloudresourcemanagerFoldersDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudresourcemanagerFoldersDelete_598045, base: "/",
    url: url_CloudresourcemanagerFoldersDelete_598046, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersMove_598085 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersMove_598087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudresourcemanagerFoldersMove_598086(path: JsonNode;
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
  var valid_598088 = path.getOrDefault("name")
  valid_598088 = validateParameter(valid_598088, JString, required = true,
                                 default = nil)
  if valid_598088 != nil:
    section.add "name", valid_598088
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
  var valid_598089 = query.getOrDefault("upload_protocol")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = nil)
  if valid_598089 != nil:
    section.add "upload_protocol", valid_598089
  var valid_598090 = query.getOrDefault("fields")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "fields", valid_598090
  var valid_598091 = query.getOrDefault("quotaUser")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "quotaUser", valid_598091
  var valid_598092 = query.getOrDefault("alt")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = newJString("json"))
  if valid_598092 != nil:
    section.add "alt", valid_598092
  var valid_598093 = query.getOrDefault("oauth_token")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "oauth_token", valid_598093
  var valid_598094 = query.getOrDefault("callback")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "callback", valid_598094
  var valid_598095 = query.getOrDefault("access_token")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "access_token", valid_598095
  var valid_598096 = query.getOrDefault("uploadType")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "uploadType", valid_598096
  var valid_598097 = query.getOrDefault("key")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "key", valid_598097
  var valid_598098 = query.getOrDefault("$.xgafv")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = newJString("1"))
  if valid_598098 != nil:
    section.add "$.xgafv", valid_598098
  var valid_598099 = query.getOrDefault("prettyPrint")
  valid_598099 = validateParameter(valid_598099, JBool, required = false,
                                 default = newJBool(true))
  if valid_598099 != nil:
    section.add "prettyPrint", valid_598099
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

proc call*(call_598101: Call_CloudresourcemanagerFoldersMove_598085;
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
  let valid = call_598101.validator(path, query, header, formData, body)
  let scheme = call_598101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598101.url(scheme.get, call_598101.host, call_598101.base,
                         call_598101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598101, url, valid)

proc call*(call_598102: Call_CloudresourcemanagerFoldersMove_598085; name: string;
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
  var path_598103 = newJObject()
  var query_598104 = newJObject()
  var body_598105 = newJObject()
  add(query_598104, "upload_protocol", newJString(uploadProtocol))
  add(query_598104, "fields", newJString(fields))
  add(query_598104, "quotaUser", newJString(quotaUser))
  add(path_598103, "name", newJString(name))
  add(query_598104, "alt", newJString(alt))
  add(query_598104, "oauth_token", newJString(oauthToken))
  add(query_598104, "callback", newJString(callback))
  add(query_598104, "access_token", newJString(accessToken))
  add(query_598104, "uploadType", newJString(uploadType))
  add(query_598104, "key", newJString(key))
  add(query_598104, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598105 = body
  add(query_598104, "prettyPrint", newJBool(prettyPrint))
  result = call_598102.call(path_598103, query_598104, nil, nil, body_598105)

var cloudresourcemanagerFoldersMove* = Call_CloudresourcemanagerFoldersMove_598085(
    name: "cloudresourcemanagerFoldersMove", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}:move",
    validator: validate_CloudresourcemanagerFoldersMove_598086, base: "/",
    url: url_CloudresourcemanagerFoldersMove_598087, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersUndelete_598106 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersUndelete_598108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudresourcemanagerFoldersUndelete_598107(path: JsonNode;
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
  var valid_598109 = path.getOrDefault("name")
  valid_598109 = validateParameter(valid_598109, JString, required = true,
                                 default = nil)
  if valid_598109 != nil:
    section.add "name", valid_598109
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
  var valid_598110 = query.getOrDefault("upload_protocol")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "upload_protocol", valid_598110
  var valid_598111 = query.getOrDefault("fields")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "fields", valid_598111
  var valid_598112 = query.getOrDefault("quotaUser")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "quotaUser", valid_598112
  var valid_598113 = query.getOrDefault("alt")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = newJString("json"))
  if valid_598113 != nil:
    section.add "alt", valid_598113
  var valid_598114 = query.getOrDefault("oauth_token")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "oauth_token", valid_598114
  var valid_598115 = query.getOrDefault("callback")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "callback", valid_598115
  var valid_598116 = query.getOrDefault("access_token")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "access_token", valid_598116
  var valid_598117 = query.getOrDefault("uploadType")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "uploadType", valid_598117
  var valid_598118 = query.getOrDefault("key")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "key", valid_598118
  var valid_598119 = query.getOrDefault("$.xgafv")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = newJString("1"))
  if valid_598119 != nil:
    section.add "$.xgafv", valid_598119
  var valid_598120 = query.getOrDefault("prettyPrint")
  valid_598120 = validateParameter(valid_598120, JBool, required = false,
                                 default = newJBool(true))
  if valid_598120 != nil:
    section.add "prettyPrint", valid_598120
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

proc call*(call_598122: Call_CloudresourcemanagerFoldersUndelete_598106;
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
  let valid = call_598122.validator(path, query, header, formData, body)
  let scheme = call_598122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598122.url(scheme.get, call_598122.host, call_598122.base,
                         call_598122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598122, url, valid)

proc call*(call_598123: Call_CloudresourcemanagerFoldersUndelete_598106;
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
  var path_598124 = newJObject()
  var query_598125 = newJObject()
  var body_598126 = newJObject()
  add(query_598125, "upload_protocol", newJString(uploadProtocol))
  add(query_598125, "fields", newJString(fields))
  add(query_598125, "quotaUser", newJString(quotaUser))
  add(path_598124, "name", newJString(name))
  add(query_598125, "alt", newJString(alt))
  add(query_598125, "oauth_token", newJString(oauthToken))
  add(query_598125, "callback", newJString(callback))
  add(query_598125, "access_token", newJString(accessToken))
  add(query_598125, "uploadType", newJString(uploadType))
  add(query_598125, "key", newJString(key))
  add(query_598125, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598126 = body
  add(query_598125, "prettyPrint", newJBool(prettyPrint))
  result = call_598123.call(path_598124, query_598125, nil, nil, body_598126)

var cloudresourcemanagerFoldersUndelete* = Call_CloudresourcemanagerFoldersUndelete_598106(
    name: "cloudresourcemanagerFoldersUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v2/{name}:undelete",
    validator: validate_CloudresourcemanagerFoldersUndelete_598107, base: "/",
    url: url_CloudresourcemanagerFoldersUndelete_598108, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersGetIamPolicy_598127 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersGetIamPolicy_598129(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudresourcemanagerFoldersGetIamPolicy_598128(path: JsonNode;
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
  var valid_598130 = path.getOrDefault("resource")
  valid_598130 = validateParameter(valid_598130, JString, required = true,
                                 default = nil)
  if valid_598130 != nil:
    section.add "resource", valid_598130
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
  var valid_598131 = query.getOrDefault("upload_protocol")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "upload_protocol", valid_598131
  var valid_598132 = query.getOrDefault("fields")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "fields", valid_598132
  var valid_598133 = query.getOrDefault("quotaUser")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "quotaUser", valid_598133
  var valid_598134 = query.getOrDefault("alt")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = newJString("json"))
  if valid_598134 != nil:
    section.add "alt", valid_598134
  var valid_598135 = query.getOrDefault("oauth_token")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "oauth_token", valid_598135
  var valid_598136 = query.getOrDefault("callback")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "callback", valid_598136
  var valid_598137 = query.getOrDefault("access_token")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "access_token", valid_598137
  var valid_598138 = query.getOrDefault("uploadType")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "uploadType", valid_598138
  var valid_598139 = query.getOrDefault("key")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "key", valid_598139
  var valid_598140 = query.getOrDefault("$.xgafv")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = newJString("1"))
  if valid_598140 != nil:
    section.add "$.xgafv", valid_598140
  var valid_598141 = query.getOrDefault("prettyPrint")
  valid_598141 = validateParameter(valid_598141, JBool, required = false,
                                 default = newJBool(true))
  if valid_598141 != nil:
    section.add "prettyPrint", valid_598141
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

proc call*(call_598143: Call_CloudresourcemanagerFoldersGetIamPolicy_598127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a Folder. The returned policy may be
  ## empty if no such policy or resource exists. The `resource` field should
  ## be the Folder's resource name, e.g. "folders/1234".
  ## The caller must have `resourcemanager.folders.getIamPolicy` permission
  ## on the identified folder.
  ## 
  let valid = call_598143.validator(path, query, header, formData, body)
  let scheme = call_598143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598143.url(scheme.get, call_598143.host, call_598143.base,
                         call_598143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598143, url, valid)

proc call*(call_598144: Call_CloudresourcemanagerFoldersGetIamPolicy_598127;
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
  var path_598145 = newJObject()
  var query_598146 = newJObject()
  var body_598147 = newJObject()
  add(query_598146, "upload_protocol", newJString(uploadProtocol))
  add(query_598146, "fields", newJString(fields))
  add(query_598146, "quotaUser", newJString(quotaUser))
  add(query_598146, "alt", newJString(alt))
  add(query_598146, "oauth_token", newJString(oauthToken))
  add(query_598146, "callback", newJString(callback))
  add(query_598146, "access_token", newJString(accessToken))
  add(query_598146, "uploadType", newJString(uploadType))
  add(query_598146, "key", newJString(key))
  add(query_598146, "$.xgafv", newJString(Xgafv))
  add(path_598145, "resource", newJString(resource))
  if body != nil:
    body_598147 = body
  add(query_598146, "prettyPrint", newJBool(prettyPrint))
  result = call_598144.call(path_598145, query_598146, nil, nil, body_598147)

var cloudresourcemanagerFoldersGetIamPolicy* = Call_CloudresourcemanagerFoldersGetIamPolicy_598127(
    name: "cloudresourcemanagerFoldersGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerFoldersGetIamPolicy_598128, base: "/",
    url: url_CloudresourcemanagerFoldersGetIamPolicy_598129,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersSetIamPolicy_598148 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersSetIamPolicy_598150(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudresourcemanagerFoldersSetIamPolicy_598149(path: JsonNode;
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
  var valid_598151 = path.getOrDefault("resource")
  valid_598151 = validateParameter(valid_598151, JString, required = true,
                                 default = nil)
  if valid_598151 != nil:
    section.add "resource", valid_598151
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
  var valid_598152 = query.getOrDefault("upload_protocol")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "upload_protocol", valid_598152
  var valid_598153 = query.getOrDefault("fields")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "fields", valid_598153
  var valid_598154 = query.getOrDefault("quotaUser")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "quotaUser", valid_598154
  var valid_598155 = query.getOrDefault("alt")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = newJString("json"))
  if valid_598155 != nil:
    section.add "alt", valid_598155
  var valid_598156 = query.getOrDefault("oauth_token")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "oauth_token", valid_598156
  var valid_598157 = query.getOrDefault("callback")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "callback", valid_598157
  var valid_598158 = query.getOrDefault("access_token")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "access_token", valid_598158
  var valid_598159 = query.getOrDefault("uploadType")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "uploadType", valid_598159
  var valid_598160 = query.getOrDefault("key")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "key", valid_598160
  var valid_598161 = query.getOrDefault("$.xgafv")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = newJString("1"))
  if valid_598161 != nil:
    section.add "$.xgafv", valid_598161
  var valid_598162 = query.getOrDefault("prettyPrint")
  valid_598162 = validateParameter(valid_598162, JBool, required = false,
                                 default = newJBool(true))
  if valid_598162 != nil:
    section.add "prettyPrint", valid_598162
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

proc call*(call_598164: Call_CloudresourcemanagerFoldersSetIamPolicy_598148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on a Folder, replacing any existing policy.
  ## The `resource` field should be the Folder's resource name, e.g.
  ## "folders/1234".
  ## The caller must have `resourcemanager.folders.setIamPolicy` permission
  ## on the identified folder.
  ## 
  let valid = call_598164.validator(path, query, header, formData, body)
  let scheme = call_598164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598164.url(scheme.get, call_598164.host, call_598164.base,
                         call_598164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598164, url, valid)

proc call*(call_598165: Call_CloudresourcemanagerFoldersSetIamPolicy_598148;
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
  var path_598166 = newJObject()
  var query_598167 = newJObject()
  var body_598168 = newJObject()
  add(query_598167, "upload_protocol", newJString(uploadProtocol))
  add(query_598167, "fields", newJString(fields))
  add(query_598167, "quotaUser", newJString(quotaUser))
  add(query_598167, "alt", newJString(alt))
  add(query_598167, "oauth_token", newJString(oauthToken))
  add(query_598167, "callback", newJString(callback))
  add(query_598167, "access_token", newJString(accessToken))
  add(query_598167, "uploadType", newJString(uploadType))
  add(query_598167, "key", newJString(key))
  add(query_598167, "$.xgafv", newJString(Xgafv))
  add(path_598166, "resource", newJString(resource))
  if body != nil:
    body_598168 = body
  add(query_598167, "prettyPrint", newJBool(prettyPrint))
  result = call_598165.call(path_598166, query_598167, nil, nil, body_598168)

var cloudresourcemanagerFoldersSetIamPolicy* = Call_CloudresourcemanagerFoldersSetIamPolicy_598148(
    name: "cloudresourcemanagerFoldersSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerFoldersSetIamPolicy_598149, base: "/",
    url: url_CloudresourcemanagerFoldersSetIamPolicy_598150,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerFoldersTestIamPermissions_598169 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerFoldersTestIamPermissions_598171(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudresourcemanagerFoldersTestIamPermissions_598170(
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
  var valid_598172 = path.getOrDefault("resource")
  valid_598172 = validateParameter(valid_598172, JString, required = true,
                                 default = nil)
  if valid_598172 != nil:
    section.add "resource", valid_598172
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
  var valid_598173 = query.getOrDefault("upload_protocol")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = nil)
  if valid_598173 != nil:
    section.add "upload_protocol", valid_598173
  var valid_598174 = query.getOrDefault("fields")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "fields", valid_598174
  var valid_598175 = query.getOrDefault("quotaUser")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "quotaUser", valid_598175
  var valid_598176 = query.getOrDefault("alt")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = newJString("json"))
  if valid_598176 != nil:
    section.add "alt", valid_598176
  var valid_598177 = query.getOrDefault("oauth_token")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "oauth_token", valid_598177
  var valid_598178 = query.getOrDefault("callback")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "callback", valid_598178
  var valid_598179 = query.getOrDefault("access_token")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "access_token", valid_598179
  var valid_598180 = query.getOrDefault("uploadType")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "uploadType", valid_598180
  var valid_598181 = query.getOrDefault("key")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "key", valid_598181
  var valid_598182 = query.getOrDefault("$.xgafv")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = newJString("1"))
  if valid_598182 != nil:
    section.add "$.xgafv", valid_598182
  var valid_598183 = query.getOrDefault("prettyPrint")
  valid_598183 = validateParameter(valid_598183, JBool, required = false,
                                 default = newJBool(true))
  if valid_598183 != nil:
    section.add "prettyPrint", valid_598183
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

proc call*(call_598185: Call_CloudresourcemanagerFoldersTestIamPermissions_598169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Folder.
  ## The `resource` field should be the Folder's resource name,
  ## e.g. "folders/1234".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_598185.validator(path, query, header, formData, body)
  let scheme = call_598185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598185.url(scheme.get, call_598185.host, call_598185.base,
                         call_598185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598185, url, valid)

proc call*(call_598186: Call_CloudresourcemanagerFoldersTestIamPermissions_598169;
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
  var path_598187 = newJObject()
  var query_598188 = newJObject()
  var body_598189 = newJObject()
  add(query_598188, "upload_protocol", newJString(uploadProtocol))
  add(query_598188, "fields", newJString(fields))
  add(query_598188, "quotaUser", newJString(quotaUser))
  add(query_598188, "alt", newJString(alt))
  add(query_598188, "oauth_token", newJString(oauthToken))
  add(query_598188, "callback", newJString(callback))
  add(query_598188, "access_token", newJString(accessToken))
  add(query_598188, "uploadType", newJString(uploadType))
  add(query_598188, "key", newJString(key))
  add(query_598188, "$.xgafv", newJString(Xgafv))
  add(path_598187, "resource", newJString(resource))
  if body != nil:
    body_598189 = body
  add(query_598188, "prettyPrint", newJBool(prettyPrint))
  result = call_598186.call(path_598187, query_598188, nil, nil, body_598189)

var cloudresourcemanagerFoldersTestIamPermissions* = Call_CloudresourcemanagerFoldersTestIamPermissions_598169(
    name: "cloudresourcemanagerFoldersTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v2/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerFoldersTestIamPermissions_598170,
    base: "/", url: url_CloudresourcemanagerFoldersTestIamPermissions_598171,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
