
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud OS Login
## version: v1alpha
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## You can use OS Login to manage access to your VM instances using IAM roles. For more information, read [OS Login](/compute/docs/oslogin/).
## 
## https://cloud.google.com/compute/docs/oslogin/
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
  gcpServiceName = "oslogin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OsloginUsersSshPublicKeysGet_588710 = ref object of OpenApiRestCall_588441
proc url_OsloginUsersSshPublicKeysGet_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OsloginUsersSshPublicKeysGet_588711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an SSH public key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The fingerprint of the public key to retrieve. Public keys are identified
  ## by their SHA-256 fingerprint. The fingerprint of the public key is in
  ## format `users/{user}/sshPublicKeys/{fingerprint}`.
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

proc call*(call_588885: Call_OsloginUsersSshPublicKeysGet_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an SSH public key.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_OsloginUsersSshPublicKeysGet_588710; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## osloginUsersSshPublicKeysGet
  ## Retrieves an SSH public key.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The fingerprint of the public key to retrieve. Public keys are identified
  ## by their SHA-256 fingerprint. The fingerprint of the public key is in
  ## format `users/{user}/sshPublicKeys/{fingerprint}`.
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

var osloginUsersSshPublicKeysGet* = Call_OsloginUsersSshPublicKeysGet_588710(
    name: "osloginUsersSshPublicKeysGet", meth: HttpMethod.HttpGet,
    host: "oslogin.googleapis.com", route: "/v1alpha/{name}",
    validator: validate_OsloginUsersSshPublicKeysGet_588711, base: "/",
    url: url_OsloginUsersSshPublicKeysGet_588712, schemes: {Scheme.Https})
type
  Call_OsloginUsersSshPublicKeysPatch_589018 = ref object of OpenApiRestCall_588441
proc url_OsloginUsersSshPublicKeysPatch_589020(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OsloginUsersSshPublicKeysPatch_589019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an SSH public key and returns the profile information. This method
  ## supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The fingerprint of the public key to update. Public keys are identified by
  ## their SHA-256 fingerprint. The fingerprint of the public key is in format
  ## `users/{user}/sshPublicKeys/{fingerprint}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589021 = path.getOrDefault("name")
  valid_589021 = validateParameter(valid_589021, JString, required = true,
                                 default = nil)
  if valid_589021 != nil:
    section.add "name", valid_589021
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
  ##             : Mask to control which fields get updated. Updates all if not present.
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
  var valid_589030 = query.getOrDefault("key")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "key", valid_589030
  var valid_589031 = query.getOrDefault("$.xgafv")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("1"))
  if valid_589031 != nil:
    section.add "$.xgafv", valid_589031
  var valid_589032 = query.getOrDefault("prettyPrint")
  valid_589032 = validateParameter(valid_589032, JBool, required = false,
                                 default = newJBool(true))
  if valid_589032 != nil:
    section.add "prettyPrint", valid_589032
  var valid_589033 = query.getOrDefault("updateMask")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "updateMask", valid_589033
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

proc call*(call_589035: Call_OsloginUsersSshPublicKeysPatch_589018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an SSH public key and returns the profile information. This method
  ## supports patch semantics.
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_OsloginUsersSshPublicKeysPatch_589018; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## osloginUsersSshPublicKeysPatch
  ## Updates an SSH public key and returns the profile information. This method
  ## supports patch semantics.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The fingerprint of the public key to update. Public keys are identified by
  ## their SHA-256 fingerprint. The fingerprint of the public key is in format
  ## `users/{user}/sshPublicKeys/{fingerprint}`.
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
  ##             : Mask to control which fields get updated. Updates all if not present.
  var path_589037 = newJObject()
  var query_589038 = newJObject()
  var body_589039 = newJObject()
  add(query_589038, "upload_protocol", newJString(uploadProtocol))
  add(query_589038, "fields", newJString(fields))
  add(query_589038, "quotaUser", newJString(quotaUser))
  add(path_589037, "name", newJString(name))
  add(query_589038, "alt", newJString(alt))
  add(query_589038, "oauth_token", newJString(oauthToken))
  add(query_589038, "callback", newJString(callback))
  add(query_589038, "access_token", newJString(accessToken))
  add(query_589038, "uploadType", newJString(uploadType))
  add(query_589038, "key", newJString(key))
  add(query_589038, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589039 = body
  add(query_589038, "prettyPrint", newJBool(prettyPrint))
  add(query_589038, "updateMask", newJString(updateMask))
  result = call_589036.call(path_589037, query_589038, nil, nil, body_589039)

var osloginUsersSshPublicKeysPatch* = Call_OsloginUsersSshPublicKeysPatch_589018(
    name: "osloginUsersSshPublicKeysPatch", meth: HttpMethod.HttpPatch,
    host: "oslogin.googleapis.com", route: "/v1alpha/{name}",
    validator: validate_OsloginUsersSshPublicKeysPatch_589019, base: "/",
    url: url_OsloginUsersSshPublicKeysPatch_589020, schemes: {Scheme.Https})
type
  Call_OsloginUsersProjectsDelete_588998 = ref object of OpenApiRestCall_588441
proc url_OsloginUsersProjectsDelete_589000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OsloginUsersProjectsDelete_588999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a POSIX account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : A reference to the POSIX account to update. POSIX accounts are identified
  ## by the project ID they are associated with. A reference to the POSIX
  ## account is in format `users/{user}/projects/{project}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589001 = path.getOrDefault("name")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "name", valid_589001
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
  ##   operatingSystemType: JString
  ##                      : The type of operating system associated with the account.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
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
  var valid_589010 = query.getOrDefault("operatingSystemType")
  valid_589010 = validateParameter(valid_589010, JString, required = false, default = newJString(
      "OPERATING_SYSTEM_TYPE_UNSPECIFIED"))
  if valid_589010 != nil:
    section.add "operatingSystemType", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("$.xgafv")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("1"))
  if valid_589012 != nil:
    section.add "$.xgafv", valid_589012
  var valid_589013 = query.getOrDefault("prettyPrint")
  valid_589013 = validateParameter(valid_589013, JBool, required = false,
                                 default = newJBool(true))
  if valid_589013 != nil:
    section.add "prettyPrint", valid_589013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589014: Call_OsloginUsersProjectsDelete_588998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a POSIX account.
  ## 
  let valid = call_589014.validator(path, query, header, formData, body)
  let scheme = call_589014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589014.url(scheme.get, call_589014.host, call_589014.base,
                         call_589014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589014, url, valid)

proc call*(call_589015: Call_OsloginUsersProjectsDelete_588998; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          operatingSystemType: string = "OPERATING_SYSTEM_TYPE_UNSPECIFIED";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## osloginUsersProjectsDelete
  ## Deletes a POSIX account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : A reference to the POSIX account to update. POSIX accounts are identified
  ## by the project ID they are associated with. A reference to the POSIX
  ## account is in format `users/{user}/projects/{project}`.
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
  ##   operatingSystemType: string
  ##                      : The type of operating system associated with the account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589016 = newJObject()
  var query_589017 = newJObject()
  add(query_589017, "upload_protocol", newJString(uploadProtocol))
  add(query_589017, "fields", newJString(fields))
  add(query_589017, "quotaUser", newJString(quotaUser))
  add(path_589016, "name", newJString(name))
  add(query_589017, "alt", newJString(alt))
  add(query_589017, "oauth_token", newJString(oauthToken))
  add(query_589017, "callback", newJString(callback))
  add(query_589017, "access_token", newJString(accessToken))
  add(query_589017, "uploadType", newJString(uploadType))
  add(query_589017, "operatingSystemType", newJString(operatingSystemType))
  add(query_589017, "key", newJString(key))
  add(query_589017, "$.xgafv", newJString(Xgafv))
  add(query_589017, "prettyPrint", newJBool(prettyPrint))
  result = call_589015.call(path_589016, query_589017, nil, nil, nil)

var osloginUsersProjectsDelete* = Call_OsloginUsersProjectsDelete_588998(
    name: "osloginUsersProjectsDelete", meth: HttpMethod.HttpDelete,
    host: "oslogin.googleapis.com", route: "/v1alpha/{name}",
    validator: validate_OsloginUsersProjectsDelete_588999, base: "/",
    url: url_OsloginUsersProjectsDelete_589000, schemes: {Scheme.Https})
type
  Call_OsloginUsersGetLoginProfile_589040 = ref object of OpenApiRestCall_588441
proc url_OsloginUsersGetLoginProfile_589042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/loginProfile")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OsloginUsersGetLoginProfile_589041(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the profile information used for logging in to a virtual machine
  ## on Google Compute Engine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique ID for the user in format `users/{user}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589043 = path.getOrDefault("name")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "name", valid_589043
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
  ##   operatingSystemType: JString
  ##                      : The type of operating system associated with the account.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project ID of the Google Cloud Platform project.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   systemId: JString
  ##           : A system ID for filtering the results of the request.
  section = newJObject()
  var valid_589044 = query.getOrDefault("upload_protocol")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "upload_protocol", valid_589044
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("callback")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "callback", valid_589049
  var valid_589050 = query.getOrDefault("access_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "access_token", valid_589050
  var valid_589051 = query.getOrDefault("uploadType")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "uploadType", valid_589051
  var valid_589052 = query.getOrDefault("operatingSystemType")
  valid_589052 = validateParameter(valid_589052, JString, required = false, default = newJString(
      "OPERATING_SYSTEM_TYPE_UNSPECIFIED"))
  if valid_589052 != nil:
    section.add "operatingSystemType", valid_589052
  var valid_589053 = query.getOrDefault("key")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "key", valid_589053
  var valid_589054 = query.getOrDefault("$.xgafv")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("1"))
  if valid_589054 != nil:
    section.add "$.xgafv", valid_589054
  var valid_589055 = query.getOrDefault("projectId")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "projectId", valid_589055
  var valid_589056 = query.getOrDefault("prettyPrint")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(true))
  if valid_589056 != nil:
    section.add "prettyPrint", valid_589056
  var valid_589057 = query.getOrDefault("systemId")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "systemId", valid_589057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589058: Call_OsloginUsersGetLoginProfile_589040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the profile information used for logging in to a virtual machine
  ## on Google Compute Engine.
  ## 
  let valid = call_589058.validator(path, query, header, formData, body)
  let scheme = call_589058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589058.url(scheme.get, call_589058.host, call_589058.base,
                         call_589058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589058, url, valid)

proc call*(call_589059: Call_OsloginUsersGetLoginProfile_589040; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          operatingSystemType: string = "OPERATING_SYSTEM_TYPE_UNSPECIFIED";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; systemId: string = ""): Recallable =
  ## osloginUsersGetLoginProfile
  ## Retrieves the profile information used for logging in to a virtual machine
  ## on Google Compute Engine.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique ID for the user in format `users/{user}`.
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
  ##   operatingSystemType: string
  ##                      : The type of operating system associated with the account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project ID of the Google Cloud Platform project.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   systemId: string
  ##           : A system ID for filtering the results of the request.
  var path_589060 = newJObject()
  var query_589061 = newJObject()
  add(query_589061, "upload_protocol", newJString(uploadProtocol))
  add(query_589061, "fields", newJString(fields))
  add(query_589061, "quotaUser", newJString(quotaUser))
  add(path_589060, "name", newJString(name))
  add(query_589061, "alt", newJString(alt))
  add(query_589061, "oauth_token", newJString(oauthToken))
  add(query_589061, "callback", newJString(callback))
  add(query_589061, "access_token", newJString(accessToken))
  add(query_589061, "uploadType", newJString(uploadType))
  add(query_589061, "operatingSystemType", newJString(operatingSystemType))
  add(query_589061, "key", newJString(key))
  add(query_589061, "$.xgafv", newJString(Xgafv))
  add(query_589061, "projectId", newJString(projectId))
  add(query_589061, "prettyPrint", newJBool(prettyPrint))
  add(query_589061, "systemId", newJString(systemId))
  result = call_589059.call(path_589060, query_589061, nil, nil, nil)

var osloginUsersGetLoginProfile* = Call_OsloginUsersGetLoginProfile_589040(
    name: "osloginUsersGetLoginProfile", meth: HttpMethod.HttpGet,
    host: "oslogin.googleapis.com", route: "/v1alpha/{name}/loginProfile",
    validator: validate_OsloginUsersGetLoginProfile_589041, base: "/",
    url: url_OsloginUsersGetLoginProfile_589042, schemes: {Scheme.Https})
type
  Call_OsloginUsersImportSshPublicKey_589062 = ref object of OpenApiRestCall_588441
proc url_OsloginUsersImportSshPublicKey_589064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":importSshPublicKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OsloginUsersImportSshPublicKey_589063(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds an SSH public key and returns the profile information. Default POSIX
  ## account information is set when no username and UID exist as part of the
  ## login profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique ID for the user in format `users/{user}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589065 = path.getOrDefault("parent")
  valid_589065 = validateParameter(valid_589065, JString, required = true,
                                 default = nil)
  if valid_589065 != nil:
    section.add "parent", valid_589065
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
  ##   projectId: JString
  ##            : The project ID of the Google Cloud Platform project.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589066 = query.getOrDefault("upload_protocol")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "upload_protocol", valid_589066
  var valid_589067 = query.getOrDefault("fields")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "fields", valid_589067
  var valid_589068 = query.getOrDefault("quotaUser")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "quotaUser", valid_589068
  var valid_589069 = query.getOrDefault("alt")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("json"))
  if valid_589069 != nil:
    section.add "alt", valid_589069
  var valid_589070 = query.getOrDefault("oauth_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "oauth_token", valid_589070
  var valid_589071 = query.getOrDefault("callback")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "callback", valid_589071
  var valid_589072 = query.getOrDefault("access_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "access_token", valid_589072
  var valid_589073 = query.getOrDefault("uploadType")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "uploadType", valid_589073
  var valid_589074 = query.getOrDefault("key")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "key", valid_589074
  var valid_589075 = query.getOrDefault("$.xgafv")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("1"))
  if valid_589075 != nil:
    section.add "$.xgafv", valid_589075
  var valid_589076 = query.getOrDefault("projectId")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "projectId", valid_589076
  var valid_589077 = query.getOrDefault("prettyPrint")
  valid_589077 = validateParameter(valid_589077, JBool, required = false,
                                 default = newJBool(true))
  if valid_589077 != nil:
    section.add "prettyPrint", valid_589077
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

proc call*(call_589079: Call_OsloginUsersImportSshPublicKey_589062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an SSH public key and returns the profile information. Default POSIX
  ## account information is set when no username and UID exist as part of the
  ## login profile.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_OsloginUsersImportSshPublicKey_589062; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; projectId: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## osloginUsersImportSshPublicKey
  ## Adds an SSH public key and returns the profile information. Default POSIX
  ## account information is set when no username and UID exist as part of the
  ## login profile.
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
  ##   parent: string (required)
  ##         : The unique ID for the user in format `users/{user}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project ID of the Google Cloud Platform project.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  var body_589083 = newJObject()
  add(query_589082, "upload_protocol", newJString(uploadProtocol))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "callback", newJString(callback))
  add(query_589082, "access_token", newJString(accessToken))
  add(query_589082, "uploadType", newJString(uploadType))
  add(path_589081, "parent", newJString(parent))
  add(query_589082, "key", newJString(key))
  add(query_589082, "$.xgafv", newJString(Xgafv))
  add(query_589082, "projectId", newJString(projectId))
  if body != nil:
    body_589083 = body
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589080.call(path_589081, query_589082, nil, nil, body_589083)

var osloginUsersImportSshPublicKey* = Call_OsloginUsersImportSshPublicKey_589062(
    name: "osloginUsersImportSshPublicKey", meth: HttpMethod.HttpPost,
    host: "oslogin.googleapis.com", route: "/v1alpha/{parent}:importSshPublicKey",
    validator: validate_OsloginUsersImportSshPublicKey_589063, base: "/",
    url: url_OsloginUsersImportSshPublicKey_589064, schemes: {Scheme.Https})
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
