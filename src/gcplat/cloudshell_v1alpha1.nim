
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Shell
## version: v1alpha1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Allows users to start, configure, and connect to interactive shell sessions running in the cloud.
## 
## 
## https://cloud.google.com/shell/docs/
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
  gcpServiceName = "cloudshell"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudshellUsersEnvironmentsGet_597677 = ref object of OpenApiRestCall_597408
proc url_CloudshellUsersEnvironmentsGet_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudshellUsersEnvironmentsGet_597678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an environment. Returns NOT_FOUND if the environment does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the requested resource, for example `users/me/environments/default`
  ## or `users/someone@example.com/environments/default`.
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

proc call*(call_597852: Call_CloudshellUsersEnvironmentsGet_597677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an environment. Returns NOT_FOUND if the environment does not exist.
  ## 
  let valid = call_597852.validator(path, query, header, formData, body)
  let scheme = call_597852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597852.url(scheme.get, call_597852.host, call_597852.base,
                         call_597852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597852, url, valid)

proc call*(call_597923: Call_CloudshellUsersEnvironmentsGet_597677; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudshellUsersEnvironmentsGet
  ## Gets an environment. Returns NOT_FOUND if the environment does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the requested resource, for example `users/me/environments/default`
  ## or `users/someone@example.com/environments/default`.
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

var cloudshellUsersEnvironmentsGet* = Call_CloudshellUsersEnvironmentsGet_597677(
    name: "cloudshellUsersEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "cloudshell.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_CloudshellUsersEnvironmentsGet_597678, base: "/",
    url: url_CloudshellUsersEnvironmentsGet_597679, schemes: {Scheme.Https})
type
  Call_CloudshellUsersEnvironmentsPatch_597984 = ref object of OpenApiRestCall_597408
proc url_CloudshellUsersEnvironmentsPatch_597986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudshellUsersEnvironmentsPatch_597985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource to be updated, for example
  ## `users/me/environments/default` or
  ## `users/someone@example.com/environments/default`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597987 = path.getOrDefault("name")
  valid_597987 = validateParameter(valid_597987, JString, required = true,
                                 default = nil)
  if valid_597987 != nil:
    section.add "name", valid_597987
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
  ##             : Mask specifying which fields in the environment should be updated.
  section = newJObject()
  var valid_597988 = query.getOrDefault("upload_protocol")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "upload_protocol", valid_597988
  var valid_597989 = query.getOrDefault("fields")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "fields", valid_597989
  var valid_597990 = query.getOrDefault("quotaUser")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "quotaUser", valid_597990
  var valid_597991 = query.getOrDefault("alt")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = newJString("json"))
  if valid_597991 != nil:
    section.add "alt", valid_597991
  var valid_597992 = query.getOrDefault("oauth_token")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "oauth_token", valid_597992
  var valid_597993 = query.getOrDefault("callback")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "callback", valid_597993
  var valid_597994 = query.getOrDefault("access_token")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "access_token", valid_597994
  var valid_597995 = query.getOrDefault("uploadType")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "uploadType", valid_597995
  var valid_597996 = query.getOrDefault("key")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "key", valid_597996
  var valid_597997 = query.getOrDefault("$.xgafv")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = newJString("1"))
  if valid_597997 != nil:
    section.add "$.xgafv", valid_597997
  var valid_597998 = query.getOrDefault("prettyPrint")
  valid_597998 = validateParameter(valid_597998, JBool, required = false,
                                 default = newJBool(true))
  if valid_597998 != nil:
    section.add "prettyPrint", valid_597998
  var valid_597999 = query.getOrDefault("updateMask")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "updateMask", valid_597999
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

proc call*(call_598001: Call_CloudshellUsersEnvironmentsPatch_597984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing environment.
  ## 
  let valid = call_598001.validator(path, query, header, formData, body)
  let scheme = call_598001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598001.url(scheme.get, call_598001.host, call_598001.base,
                         call_598001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598001, url, valid)

proc call*(call_598002: Call_CloudshellUsersEnvironmentsPatch_597984; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## cloudshellUsersEnvironmentsPatch
  ## Updates an existing environment.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the resource to be updated, for example
  ## `users/me/environments/default` or
  ## `users/someone@example.com/environments/default`.
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
  ##             : Mask specifying which fields in the environment should be updated.
  var path_598003 = newJObject()
  var query_598004 = newJObject()
  var body_598005 = newJObject()
  add(query_598004, "upload_protocol", newJString(uploadProtocol))
  add(query_598004, "fields", newJString(fields))
  add(query_598004, "quotaUser", newJString(quotaUser))
  add(path_598003, "name", newJString(name))
  add(query_598004, "alt", newJString(alt))
  add(query_598004, "oauth_token", newJString(oauthToken))
  add(query_598004, "callback", newJString(callback))
  add(query_598004, "access_token", newJString(accessToken))
  add(query_598004, "uploadType", newJString(uploadType))
  add(query_598004, "key", newJString(key))
  add(query_598004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598005 = body
  add(query_598004, "prettyPrint", newJBool(prettyPrint))
  add(query_598004, "updateMask", newJString(updateMask))
  result = call_598002.call(path_598003, query_598004, nil, nil, body_598005)

var cloudshellUsersEnvironmentsPatch* = Call_CloudshellUsersEnvironmentsPatch_597984(
    name: "cloudshellUsersEnvironmentsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudshell.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_CloudshellUsersEnvironmentsPatch_597985, base: "/",
    url: url_CloudshellUsersEnvironmentsPatch_597986, schemes: {Scheme.Https})
type
  Call_CloudshellUsersEnvironmentsPublicKeysDelete_597965 = ref object of OpenApiRestCall_597408
proc url_CloudshellUsersEnvironmentsPublicKeysDelete_597967(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudshellUsersEnvironmentsPublicKeysDelete_597966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a public SSH key from an environment. Clients will no longer be
  ## able to connect to the environment using the corresponding private key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource to be deleted, e.g.
  ## `users/me/environments/default/publicKeys/my-key`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597968 = path.getOrDefault("name")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "name", valid_597968
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
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
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
  var valid_597977 = query.getOrDefault("key")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "key", valid_597977
  var valid_597978 = query.getOrDefault("$.xgafv")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("1"))
  if valid_597978 != nil:
    section.add "$.xgafv", valid_597978
  var valid_597979 = query.getOrDefault("prettyPrint")
  valid_597979 = validateParameter(valid_597979, JBool, required = false,
                                 default = newJBool(true))
  if valid_597979 != nil:
    section.add "prettyPrint", valid_597979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597980: Call_CloudshellUsersEnvironmentsPublicKeysDelete_597965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a public SSH key from an environment. Clients will no longer be
  ## able to connect to the environment using the corresponding private key.
  ## 
  let valid = call_597980.validator(path, query, header, formData, body)
  let scheme = call_597980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597980.url(scheme.get, call_597980.host, call_597980.base,
                         call_597980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597980, url, valid)

proc call*(call_597981: Call_CloudshellUsersEnvironmentsPublicKeysDelete_597965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudshellUsersEnvironmentsPublicKeysDelete
  ## Removes a public SSH key from an environment. Clients will no longer be
  ## able to connect to the environment using the corresponding private key.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the resource to be deleted, e.g.
  ## `users/me/environments/default/publicKeys/my-key`.
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
  var path_597982 = newJObject()
  var query_597983 = newJObject()
  add(query_597983, "upload_protocol", newJString(uploadProtocol))
  add(query_597983, "fields", newJString(fields))
  add(query_597983, "quotaUser", newJString(quotaUser))
  add(path_597982, "name", newJString(name))
  add(query_597983, "alt", newJString(alt))
  add(query_597983, "oauth_token", newJString(oauthToken))
  add(query_597983, "callback", newJString(callback))
  add(query_597983, "access_token", newJString(accessToken))
  add(query_597983, "uploadType", newJString(uploadType))
  add(query_597983, "key", newJString(key))
  add(query_597983, "$.xgafv", newJString(Xgafv))
  add(query_597983, "prettyPrint", newJBool(prettyPrint))
  result = call_597981.call(path_597982, query_597983, nil, nil, nil)

var cloudshellUsersEnvironmentsPublicKeysDelete* = Call_CloudshellUsersEnvironmentsPublicKeysDelete_597965(
    name: "cloudshellUsersEnvironmentsPublicKeysDelete",
    meth: HttpMethod.HttpDelete, host: "cloudshell.googleapis.com",
    route: "/v1alpha1/{name}",
    validator: validate_CloudshellUsersEnvironmentsPublicKeysDelete_597966,
    base: "/", url: url_CloudshellUsersEnvironmentsPublicKeysDelete_597967,
    schemes: {Scheme.Https})
type
  Call_CloudshellUsersEnvironmentsAuthorize_598006 = ref object of OpenApiRestCall_597408
proc url_CloudshellUsersEnvironmentsAuthorize_598008(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":authorize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudshellUsersEnvironmentsAuthorize_598007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends OAuth credentials to a running environment on behalf of a user. When
  ## this completes, the environment will be authorized to run various Google
  ## Cloud command line tools without requiring the user to manually
  ## authenticate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource that should receive the credentials, for example
  ## `users/me/environments/default` or
  ## `users/someone@example.com/environments/default`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598009 = path.getOrDefault("name")
  valid_598009 = validateParameter(valid_598009, JString, required = true,
                                 default = nil)
  if valid_598009 != nil:
    section.add "name", valid_598009
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
  var valid_598010 = query.getOrDefault("upload_protocol")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "upload_protocol", valid_598010
  var valid_598011 = query.getOrDefault("fields")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "fields", valid_598011
  var valid_598012 = query.getOrDefault("quotaUser")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "quotaUser", valid_598012
  var valid_598013 = query.getOrDefault("alt")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = newJString("json"))
  if valid_598013 != nil:
    section.add "alt", valid_598013
  var valid_598014 = query.getOrDefault("oauth_token")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "oauth_token", valid_598014
  var valid_598015 = query.getOrDefault("callback")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "callback", valid_598015
  var valid_598016 = query.getOrDefault("access_token")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "access_token", valid_598016
  var valid_598017 = query.getOrDefault("uploadType")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "uploadType", valid_598017
  var valid_598018 = query.getOrDefault("key")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "key", valid_598018
  var valid_598019 = query.getOrDefault("$.xgafv")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = newJString("1"))
  if valid_598019 != nil:
    section.add "$.xgafv", valid_598019
  var valid_598020 = query.getOrDefault("prettyPrint")
  valid_598020 = validateParameter(valid_598020, JBool, required = false,
                                 default = newJBool(true))
  if valid_598020 != nil:
    section.add "prettyPrint", valid_598020
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

proc call*(call_598022: Call_CloudshellUsersEnvironmentsAuthorize_598006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sends OAuth credentials to a running environment on behalf of a user. When
  ## this completes, the environment will be authorized to run various Google
  ## Cloud command line tools without requiring the user to manually
  ## authenticate.
  ## 
  let valid = call_598022.validator(path, query, header, formData, body)
  let scheme = call_598022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598022.url(scheme.get, call_598022.host, call_598022.base,
                         call_598022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598022, url, valid)

proc call*(call_598023: Call_CloudshellUsersEnvironmentsAuthorize_598006;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudshellUsersEnvironmentsAuthorize
  ## Sends OAuth credentials to a running environment on behalf of a user. When
  ## this completes, the environment will be authorized to run various Google
  ## Cloud command line tools without requiring the user to manually
  ## authenticate.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the resource that should receive the credentials, for example
  ## `users/me/environments/default` or
  ## `users/someone@example.com/environments/default`.
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
  var path_598024 = newJObject()
  var query_598025 = newJObject()
  var body_598026 = newJObject()
  add(query_598025, "upload_protocol", newJString(uploadProtocol))
  add(query_598025, "fields", newJString(fields))
  add(query_598025, "quotaUser", newJString(quotaUser))
  add(path_598024, "name", newJString(name))
  add(query_598025, "alt", newJString(alt))
  add(query_598025, "oauth_token", newJString(oauthToken))
  add(query_598025, "callback", newJString(callback))
  add(query_598025, "access_token", newJString(accessToken))
  add(query_598025, "uploadType", newJString(uploadType))
  add(query_598025, "key", newJString(key))
  add(query_598025, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598026 = body
  add(query_598025, "prettyPrint", newJBool(prettyPrint))
  result = call_598023.call(path_598024, query_598025, nil, nil, body_598026)

var cloudshellUsersEnvironmentsAuthorize* = Call_CloudshellUsersEnvironmentsAuthorize_598006(
    name: "cloudshellUsersEnvironmentsAuthorize", meth: HttpMethod.HttpPost,
    host: "cloudshell.googleapis.com", route: "/v1alpha1/{name}:authorize",
    validator: validate_CloudshellUsersEnvironmentsAuthorize_598007, base: "/",
    url: url_CloudshellUsersEnvironmentsAuthorize_598008, schemes: {Scheme.Https})
type
  Call_CloudshellUsersEnvironmentsStart_598027 = ref object of OpenApiRestCall_597408
proc url_CloudshellUsersEnvironmentsStart_598029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudshellUsersEnvironmentsStart_598028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts an existing environment, allowing clients to connect to it. The
  ## returned operation will contain an instance of StartEnvironmentMetadata in
  ## its metadata field. Users can wait for the environment to start by polling
  ## this operation via GetOperation. Once the environment has finished starting
  ## and is ready to accept connections, the operation will contain a
  ## StartEnvironmentResponse in its response field.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource that should be started, for example
  ## `users/me/environments/default` or
  ## `users/someone@example.com/environments/default`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598030 = path.getOrDefault("name")
  valid_598030 = validateParameter(valid_598030, JString, required = true,
                                 default = nil)
  if valid_598030 != nil:
    section.add "name", valid_598030
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
  var valid_598031 = query.getOrDefault("upload_protocol")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "upload_protocol", valid_598031
  var valid_598032 = query.getOrDefault("fields")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "fields", valid_598032
  var valid_598033 = query.getOrDefault("quotaUser")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "quotaUser", valid_598033
  var valid_598034 = query.getOrDefault("alt")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = newJString("json"))
  if valid_598034 != nil:
    section.add "alt", valid_598034
  var valid_598035 = query.getOrDefault("oauth_token")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "oauth_token", valid_598035
  var valid_598036 = query.getOrDefault("callback")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "callback", valid_598036
  var valid_598037 = query.getOrDefault("access_token")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "access_token", valid_598037
  var valid_598038 = query.getOrDefault("uploadType")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "uploadType", valid_598038
  var valid_598039 = query.getOrDefault("key")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "key", valid_598039
  var valid_598040 = query.getOrDefault("$.xgafv")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = newJString("1"))
  if valid_598040 != nil:
    section.add "$.xgafv", valid_598040
  var valid_598041 = query.getOrDefault("prettyPrint")
  valid_598041 = validateParameter(valid_598041, JBool, required = false,
                                 default = newJBool(true))
  if valid_598041 != nil:
    section.add "prettyPrint", valid_598041
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

proc call*(call_598043: Call_CloudshellUsersEnvironmentsStart_598027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts an existing environment, allowing clients to connect to it. The
  ## returned operation will contain an instance of StartEnvironmentMetadata in
  ## its metadata field. Users can wait for the environment to start by polling
  ## this operation via GetOperation. Once the environment has finished starting
  ## and is ready to accept connections, the operation will contain a
  ## StartEnvironmentResponse in its response field.
  ## 
  let valid = call_598043.validator(path, query, header, formData, body)
  let scheme = call_598043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598043.url(scheme.get, call_598043.host, call_598043.base,
                         call_598043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598043, url, valid)

proc call*(call_598044: Call_CloudshellUsersEnvironmentsStart_598027; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudshellUsersEnvironmentsStart
  ## Starts an existing environment, allowing clients to connect to it. The
  ## returned operation will contain an instance of StartEnvironmentMetadata in
  ## its metadata field. Users can wait for the environment to start by polling
  ## this operation via GetOperation. Once the environment has finished starting
  ## and is ready to accept connections, the operation will contain a
  ## StartEnvironmentResponse in its response field.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the resource that should be started, for example
  ## `users/me/environments/default` or
  ## `users/someone@example.com/environments/default`.
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
  var path_598045 = newJObject()
  var query_598046 = newJObject()
  var body_598047 = newJObject()
  add(query_598046, "upload_protocol", newJString(uploadProtocol))
  add(query_598046, "fields", newJString(fields))
  add(query_598046, "quotaUser", newJString(quotaUser))
  add(path_598045, "name", newJString(name))
  add(query_598046, "alt", newJString(alt))
  add(query_598046, "oauth_token", newJString(oauthToken))
  add(query_598046, "callback", newJString(callback))
  add(query_598046, "access_token", newJString(accessToken))
  add(query_598046, "uploadType", newJString(uploadType))
  add(query_598046, "key", newJString(key))
  add(query_598046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598047 = body
  add(query_598046, "prettyPrint", newJBool(prettyPrint))
  result = call_598044.call(path_598045, query_598046, nil, nil, body_598047)

var cloudshellUsersEnvironmentsStart* = Call_CloudshellUsersEnvironmentsStart_598027(
    name: "cloudshellUsersEnvironmentsStart", meth: HttpMethod.HttpPost,
    host: "cloudshell.googleapis.com", route: "/v1alpha1/{name}:start",
    validator: validate_CloudshellUsersEnvironmentsStart_598028, base: "/",
    url: url_CloudshellUsersEnvironmentsStart_598029, schemes: {Scheme.Https})
type
  Call_CloudshellUsersEnvironmentsPublicKeysCreate_598048 = ref object of OpenApiRestCall_597408
proc url_CloudshellUsersEnvironmentsPublicKeysCreate_598050(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/publicKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudshellUsersEnvironmentsPublicKeysCreate_598049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a public SSH key to an environment, allowing clients with the
  ## corresponding private key to connect to that environment via SSH. If a key
  ## with the same format and content already exists, this will return the
  ## existing key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent resource name, e.g. `users/me/environments/default`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_598051 = path.getOrDefault("parent")
  valid_598051 = validateParameter(valid_598051, JString, required = true,
                                 default = nil)
  if valid_598051 != nil:
    section.add "parent", valid_598051
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
  var valid_598052 = query.getOrDefault("upload_protocol")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "upload_protocol", valid_598052
  var valid_598053 = query.getOrDefault("fields")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "fields", valid_598053
  var valid_598054 = query.getOrDefault("quotaUser")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "quotaUser", valid_598054
  var valid_598055 = query.getOrDefault("alt")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = newJString("json"))
  if valid_598055 != nil:
    section.add "alt", valid_598055
  var valid_598056 = query.getOrDefault("oauth_token")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "oauth_token", valid_598056
  var valid_598057 = query.getOrDefault("callback")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "callback", valid_598057
  var valid_598058 = query.getOrDefault("access_token")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "access_token", valid_598058
  var valid_598059 = query.getOrDefault("uploadType")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "uploadType", valid_598059
  var valid_598060 = query.getOrDefault("key")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "key", valid_598060
  var valid_598061 = query.getOrDefault("$.xgafv")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = newJString("1"))
  if valid_598061 != nil:
    section.add "$.xgafv", valid_598061
  var valid_598062 = query.getOrDefault("prettyPrint")
  valid_598062 = validateParameter(valid_598062, JBool, required = false,
                                 default = newJBool(true))
  if valid_598062 != nil:
    section.add "prettyPrint", valid_598062
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

proc call*(call_598064: Call_CloudshellUsersEnvironmentsPublicKeysCreate_598048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a public SSH key to an environment, allowing clients with the
  ## corresponding private key to connect to that environment via SSH. If a key
  ## with the same format and content already exists, this will return the
  ## existing key.
  ## 
  let valid = call_598064.validator(path, query, header, formData, body)
  let scheme = call_598064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598064.url(scheme.get, call_598064.host, call_598064.base,
                         call_598064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598064, url, valid)

proc call*(call_598065: Call_CloudshellUsersEnvironmentsPublicKeysCreate_598048;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudshellUsersEnvironmentsPublicKeysCreate
  ## Adds a public SSH key to an environment, allowing clients with the
  ## corresponding private key to connect to that environment via SSH. If a key
  ## with the same format and content already exists, this will return the
  ## existing key.
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
  ##         : Parent resource name, e.g. `users/me/environments/default`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598066 = newJObject()
  var query_598067 = newJObject()
  var body_598068 = newJObject()
  add(query_598067, "upload_protocol", newJString(uploadProtocol))
  add(query_598067, "fields", newJString(fields))
  add(query_598067, "quotaUser", newJString(quotaUser))
  add(query_598067, "alt", newJString(alt))
  add(query_598067, "oauth_token", newJString(oauthToken))
  add(query_598067, "callback", newJString(callback))
  add(query_598067, "access_token", newJString(accessToken))
  add(query_598067, "uploadType", newJString(uploadType))
  add(path_598066, "parent", newJString(parent))
  add(query_598067, "key", newJString(key))
  add(query_598067, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598068 = body
  add(query_598067, "prettyPrint", newJBool(prettyPrint))
  result = call_598065.call(path_598066, query_598067, nil, nil, body_598068)

var cloudshellUsersEnvironmentsPublicKeysCreate* = Call_CloudshellUsersEnvironmentsPublicKeysCreate_598048(
    name: "cloudshellUsersEnvironmentsPublicKeysCreate",
    meth: HttpMethod.HttpPost, host: "cloudshell.googleapis.com",
    route: "/v1alpha1/{parent}/publicKeys",
    validator: validate_CloudshellUsersEnvironmentsPublicKeysCreate_598049,
    base: "/", url: url_CloudshellUsersEnvironmentsPublicKeysCreate_598050,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
