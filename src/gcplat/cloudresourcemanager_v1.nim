
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Resource Manager
## version: v1
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  Call_CloudresourcemanagerLiensCreate_588994 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerLiensCreate_588996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerLiensCreate_588995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a Lien which applies to the resource denoted by the `parent` field.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, applying to `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  ## NOTE: Some resources may limit the number of Liens which may be applied.
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
  var valid_588997 = query.getOrDefault("upload_protocol")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "upload_protocol", valid_588997
  var valid_588998 = query.getOrDefault("fields")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "fields", valid_588998
  var valid_588999 = query.getOrDefault("quotaUser")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "quotaUser", valid_588999
  var valid_589000 = query.getOrDefault("alt")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = newJString("json"))
  if valid_589000 != nil:
    section.add "alt", valid_589000
  var valid_589001 = query.getOrDefault("oauth_token")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "oauth_token", valid_589001
  var valid_589002 = query.getOrDefault("callback")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "callback", valid_589002
  var valid_589003 = query.getOrDefault("access_token")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "access_token", valid_589003
  var valid_589004 = query.getOrDefault("uploadType")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "uploadType", valid_589004
  var valid_589005 = query.getOrDefault("key")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "key", valid_589005
  var valid_589006 = query.getOrDefault("$.xgafv")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("1"))
  if valid_589006 != nil:
    section.add "$.xgafv", valid_589006
  var valid_589007 = query.getOrDefault("prettyPrint")
  valid_589007 = validateParameter(valid_589007, JBool, required = false,
                                 default = newJBool(true))
  if valid_589007 != nil:
    section.add "prettyPrint", valid_589007
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

proc call*(call_589009: Call_CloudresourcemanagerLiensCreate_588994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a Lien which applies to the resource denoted by the `parent` field.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, applying to `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  ## NOTE: Some resources may limit the number of Liens which may be applied.
  ## 
  let valid = call_589009.validator(path, query, header, formData, body)
  let scheme = call_589009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589009.url(scheme.get, call_589009.host, call_589009.base,
                         call_589009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589009, url, valid)

proc call*(call_589010: Call_CloudresourcemanagerLiensCreate_588994;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerLiensCreate
  ## Create a Lien which applies to the resource denoted by the `parent` field.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, applying to `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  ## NOTE: Some resources may limit the number of Liens which may be applied.
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
  var query_589011 = newJObject()
  var body_589012 = newJObject()
  add(query_589011, "upload_protocol", newJString(uploadProtocol))
  add(query_589011, "fields", newJString(fields))
  add(query_589011, "quotaUser", newJString(quotaUser))
  add(query_589011, "alt", newJString(alt))
  add(query_589011, "oauth_token", newJString(oauthToken))
  add(query_589011, "callback", newJString(callback))
  add(query_589011, "access_token", newJString(accessToken))
  add(query_589011, "uploadType", newJString(uploadType))
  add(query_589011, "key", newJString(key))
  add(query_589011, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589012 = body
  add(query_589011, "prettyPrint", newJBool(prettyPrint))
  result = call_589010.call(nil, query_589011, nil, nil, body_589012)

var cloudresourcemanagerLiensCreate* = Call_CloudresourcemanagerLiensCreate_588994(
    name: "cloudresourcemanagerLiensCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/liens",
    validator: validate_CloudresourcemanagerLiensCreate_588995, base: "/",
    url: url_CloudresourcemanagerLiensCreate_588996, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerLiensList_588719 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerLiensList_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerLiensList_588720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all Liens applied to the `parent` resource.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.get`.
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
  ##            : The `next_page_token` value returned from a previous List request, if any.
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
  ##         : The name of the resource to list all attached Liens.
  ## For example, `projects/1234`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return. This is a suggestion for the server.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("pageToken")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "pageToken", valid_588835
  var valid_588836 = query.getOrDefault("quotaUser")
  valid_588836 = validateParameter(valid_588836, JString, required = false,
                                 default = nil)
  if valid_588836 != nil:
    section.add "quotaUser", valid_588836
  var valid_588850 = query.getOrDefault("alt")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = newJString("json"))
  if valid_588850 != nil:
    section.add "alt", valid_588850
  var valid_588851 = query.getOrDefault("oauth_token")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "oauth_token", valid_588851
  var valid_588852 = query.getOrDefault("callback")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "callback", valid_588852
  var valid_588853 = query.getOrDefault("access_token")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "access_token", valid_588853
  var valid_588854 = query.getOrDefault("uploadType")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "uploadType", valid_588854
  var valid_588855 = query.getOrDefault("parent")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "parent", valid_588855
  var valid_588856 = query.getOrDefault("key")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "key", valid_588856
  var valid_588857 = query.getOrDefault("$.xgafv")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("1"))
  if valid_588857 != nil:
    section.add "$.xgafv", valid_588857
  var valid_588858 = query.getOrDefault("pageSize")
  valid_588858 = validateParameter(valid_588858, JInt, required = false, default = nil)
  if valid_588858 != nil:
    section.add "pageSize", valid_588858
  var valid_588859 = query.getOrDefault("prettyPrint")
  valid_588859 = validateParameter(valid_588859, JBool, required = false,
                                 default = newJBool(true))
  if valid_588859 != nil:
    section.add "prettyPrint", valid_588859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588882: Call_CloudresourcemanagerLiensList_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all Liens applied to the `parent` resource.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.get`.
  ## 
  let valid = call_588882.validator(path, query, header, formData, body)
  let scheme = call_588882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588882.url(scheme.get, call_588882.host, call_588882.base,
                         call_588882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588882, url, valid)

proc call*(call_588953: Call_CloudresourcemanagerLiensList_588719;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          parent: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerLiensList
  ## List all Liens applied to the `parent` resource.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.get`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The `next_page_token` value returned from a previous List request, if any.
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
  ##         : The name of the resource to list all attached Liens.
  ## For example, `projects/1234`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. This is a suggestion for the server.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588954 = newJObject()
  add(query_588954, "upload_protocol", newJString(uploadProtocol))
  add(query_588954, "fields", newJString(fields))
  add(query_588954, "pageToken", newJString(pageToken))
  add(query_588954, "quotaUser", newJString(quotaUser))
  add(query_588954, "alt", newJString(alt))
  add(query_588954, "oauth_token", newJString(oauthToken))
  add(query_588954, "callback", newJString(callback))
  add(query_588954, "access_token", newJString(accessToken))
  add(query_588954, "uploadType", newJString(uploadType))
  add(query_588954, "parent", newJString(parent))
  add(query_588954, "key", newJString(key))
  add(query_588954, "$.xgafv", newJString(Xgafv))
  add(query_588954, "pageSize", newJInt(pageSize))
  add(query_588954, "prettyPrint", newJBool(prettyPrint))
  result = call_588953.call(nil, query_588954, nil, nil, nil)

var cloudresourcemanagerLiensList* = Call_CloudresourcemanagerLiensList_588719(
    name: "cloudresourcemanagerLiensList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/liens",
    validator: validate_CloudresourcemanagerLiensList_588720, base: "/",
    url: url_CloudresourcemanagerLiensList_588721, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSearch_589013 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsSearch_589015(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerOrganizationsSearch_589014(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the
  ## results.
  ## 
  ## Search will only return organizations on which the user has the permission
  ## `resourcemanager.organizations.get`
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
  var valid_589016 = query.getOrDefault("upload_protocol")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "upload_protocol", valid_589016
  var valid_589017 = query.getOrDefault("fields")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "fields", valid_589017
  var valid_589018 = query.getOrDefault("quotaUser")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "quotaUser", valid_589018
  var valid_589019 = query.getOrDefault("alt")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = newJString("json"))
  if valid_589019 != nil:
    section.add "alt", valid_589019
  var valid_589020 = query.getOrDefault("oauth_token")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "oauth_token", valid_589020
  var valid_589021 = query.getOrDefault("callback")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "callback", valid_589021
  var valid_589022 = query.getOrDefault("access_token")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "access_token", valid_589022
  var valid_589023 = query.getOrDefault("uploadType")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "uploadType", valid_589023
  var valid_589024 = query.getOrDefault("key")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "key", valid_589024
  var valid_589025 = query.getOrDefault("$.xgafv")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("1"))
  if valid_589025 != nil:
    section.add "$.xgafv", valid_589025
  var valid_589026 = query.getOrDefault("prettyPrint")
  valid_589026 = validateParameter(valid_589026, JBool, required = false,
                                 default = newJBool(true))
  if valid_589026 != nil:
    section.add "prettyPrint", valid_589026
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

proc call*(call_589028: Call_CloudresourcemanagerOrganizationsSearch_589013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Searches Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the
  ## results.
  ## 
  ## Search will only return organizations on which the user has the permission
  ## `resourcemanager.organizations.get`
  ## 
  let valid = call_589028.validator(path, query, header, formData, body)
  let scheme = call_589028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589028.url(scheme.get, call_589028.host, call_589028.base,
                         call_589028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589028, url, valid)

proc call*(call_589029: Call_CloudresourcemanagerOrganizationsSearch_589013;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsSearch
  ## Searches Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the
  ## results.
  ## 
  ## Search will only return organizations on which the user has the permission
  ## `resourcemanager.organizations.get`
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
  var query_589030 = newJObject()
  var body_589031 = newJObject()
  add(query_589030, "upload_protocol", newJString(uploadProtocol))
  add(query_589030, "fields", newJString(fields))
  add(query_589030, "quotaUser", newJString(quotaUser))
  add(query_589030, "alt", newJString(alt))
  add(query_589030, "oauth_token", newJString(oauthToken))
  add(query_589030, "callback", newJString(callback))
  add(query_589030, "access_token", newJString(accessToken))
  add(query_589030, "uploadType", newJString(uploadType))
  add(query_589030, "key", newJString(key))
  add(query_589030, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589031 = body
  add(query_589030, "prettyPrint", newJBool(prettyPrint))
  result = call_589029.call(nil, query_589030, nil, nil, body_589031)

var cloudresourcemanagerOrganizationsSearch* = Call_CloudresourcemanagerOrganizationsSearch_589013(
    name: "cloudresourcemanagerOrganizationsSearch", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/organizations:search",
    validator: validate_CloudresourcemanagerOrganizationsSearch_589014, base: "/",
    url: url_CloudresourcemanagerOrganizationsSearch_589015,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsCreate_589052 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerProjectsCreate_589054(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsCreate_589053(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request that a new Project be created. The result is an Operation which
  ## can be used to track the creation process. This process usually takes a few
  ## seconds, but can sometimes take much longer. The tracking Operation is
  ## automatically deleted after a few hours, so there is no need to call
  ## DeleteOperation.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.create` on the specified parent for the new
  ## project. The parent is identified by a specified ResourceId,
  ## which must include both an ID and a type, such as organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
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
  var valid_589055 = query.getOrDefault("upload_protocol")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "upload_protocol", valid_589055
  var valid_589056 = query.getOrDefault("fields")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "fields", valid_589056
  var valid_589057 = query.getOrDefault("quotaUser")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "quotaUser", valid_589057
  var valid_589058 = query.getOrDefault("alt")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = newJString("json"))
  if valid_589058 != nil:
    section.add "alt", valid_589058
  var valid_589059 = query.getOrDefault("oauth_token")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "oauth_token", valid_589059
  var valid_589060 = query.getOrDefault("callback")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "callback", valid_589060
  var valid_589061 = query.getOrDefault("access_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "access_token", valid_589061
  var valid_589062 = query.getOrDefault("uploadType")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "uploadType", valid_589062
  var valid_589063 = query.getOrDefault("key")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "key", valid_589063
  var valid_589064 = query.getOrDefault("$.xgafv")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = newJString("1"))
  if valid_589064 != nil:
    section.add "$.xgafv", valid_589064
  var valid_589065 = query.getOrDefault("prettyPrint")
  valid_589065 = validateParameter(valid_589065, JBool, required = false,
                                 default = newJBool(true))
  if valid_589065 != nil:
    section.add "prettyPrint", valid_589065
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

proc call*(call_589067: Call_CloudresourcemanagerProjectsCreate_589052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request that a new Project be created. The result is an Operation which
  ## can be used to track the creation process. This process usually takes a few
  ## seconds, but can sometimes take much longer. The tracking Operation is
  ## automatically deleted after a few hours, so there is no need to call
  ## DeleteOperation.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.create` on the specified parent for the new
  ## project. The parent is identified by a specified ResourceId,
  ## which must include both an ID and a type, such as organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
  ## 
  let valid = call_589067.validator(path, query, header, formData, body)
  let scheme = call_589067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589067.url(scheme.get, call_589067.host, call_589067.base,
                         call_589067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589067, url, valid)

proc call*(call_589068: Call_CloudresourcemanagerProjectsCreate_589052;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsCreate
  ## Request that a new Project be created. The result is an Operation which
  ## can be used to track the creation process. This process usually takes a few
  ## seconds, but can sometimes take much longer. The tracking Operation is
  ## automatically deleted after a few hours, so there is no need to call
  ## DeleteOperation.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.create` on the specified parent for the new
  ## project. The parent is identified by a specified ResourceId,
  ## which must include both an ID and a type, such as organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
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
  var query_589069 = newJObject()
  var body_589070 = newJObject()
  add(query_589069, "upload_protocol", newJString(uploadProtocol))
  add(query_589069, "fields", newJString(fields))
  add(query_589069, "quotaUser", newJString(quotaUser))
  add(query_589069, "alt", newJString(alt))
  add(query_589069, "oauth_token", newJString(oauthToken))
  add(query_589069, "callback", newJString(callback))
  add(query_589069, "access_token", newJString(accessToken))
  add(query_589069, "uploadType", newJString(uploadType))
  add(query_589069, "key", newJString(key))
  add(query_589069, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589070 = body
  add(query_589069, "prettyPrint", newJBool(prettyPrint))
  result = call_589068.call(nil, query_589069, nil, nil, body_589070)

var cloudresourcemanagerProjectsCreate* = Call_CloudresourcemanagerProjectsCreate_589052(
    name: "cloudresourcemanagerProjectsCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/projects",
    validator: validate_CloudresourcemanagerProjectsCreate_589053, base: "/",
    url: url_CloudresourcemanagerProjectsCreate_589054, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsList_589032 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerProjectsList_589034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsList_589033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Projects that the caller has the `resourcemanager.projects.get`
  ## permission on and satisfy the specified filter.
  ## 
  ## This method returns Projects in an unspecified order.
  ## This method is eventually consistent with project mutations; this means
  ## that a newly created project may not appear in the results or recent
  ## updates to an existing project may not be reflected in the results. To
  ## retrieve the latest state of a project, use the
  ## GetProject method.
  ## 
  ## NOTE: If the request filter contains a `parent.type` and `parent.id` and
  ## the caller has the `resourcemanager.projects.list` permission on the
  ## parent, the results will be drawn from an alternate index which provides
  ## more consistent results. In future versions of this API, this List method
  ## will be split into List and Search to properly capture the behavorial
  ## difference.
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
  ##            : A pagination token returned from a previous call to ListProjects
  ## that indicates from where listing should continue.
  ## 
  ## Optional.
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
  ##   pageSize: JInt
  ##           : The maximum number of Projects to return in the response.
  ## The server can return fewer Projects than requested.
  ## If unspecified, server picks an appropriate default.
  ## 
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : An expression for filtering the results of the request.  Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ## + `name`
  ## + `id`
  ## + `labels.<key>` (where *key* is the name of a label)
  ## + `parent.type`
  ## + `parent.id`
  ## 
  ## Some examples of using labels as filters:
  ## 
  ## | Filter           | Description                                         |
  ## |------------------|-----------------------------------------------------|
  ## | name:how*        | The project's name starts with "how".               |
  ## | name:Howl        | The project's name is `Howl` or `howl`.             |
  ## | name:HOWL        | Equivalent to above.                                |
  ## | NAME:howl        | Equivalent to above.                                |
  ## | labels.color:*   | The project has the label `color`.                  |
  ## | labels.color:red | The project's label `color` has the value `red`.    |
  ## | labels.color:red&nbsp;labels.size:big |The project's label `color` has
  ##   the value `red` and its label `size` has the value `big`.              |
  ## 
  ## If no filter is specified, the call will return projects for which the user
  ## has the `resourcemanager.projects.get` permission.
  ## 
  ## NOTE: To perform a by-parent query (eg., what projects are directly in a
  ## Folder), the caller must have the `resourcemanager.projects.list`
  ## permission on the parent and the filter must contain both a `parent.type`
  ## and a `parent.id` restriction
  ## (example: "parent.type:folder parent.id:123"). In this case an alternate
  ## search index is used which provides more consistent results.
  ## 
  ## Optional.
  section = newJObject()
  var valid_589035 = query.getOrDefault("upload_protocol")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "upload_protocol", valid_589035
  var valid_589036 = query.getOrDefault("fields")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "fields", valid_589036
  var valid_589037 = query.getOrDefault("pageToken")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "pageToken", valid_589037
  var valid_589038 = query.getOrDefault("quotaUser")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "quotaUser", valid_589038
  var valid_589039 = query.getOrDefault("alt")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("json"))
  if valid_589039 != nil:
    section.add "alt", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("callback")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "callback", valid_589041
  var valid_589042 = query.getOrDefault("access_token")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "access_token", valid_589042
  var valid_589043 = query.getOrDefault("uploadType")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "uploadType", valid_589043
  var valid_589044 = query.getOrDefault("key")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "key", valid_589044
  var valid_589045 = query.getOrDefault("$.xgafv")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = newJString("1"))
  if valid_589045 != nil:
    section.add "$.xgafv", valid_589045
  var valid_589046 = query.getOrDefault("pageSize")
  valid_589046 = validateParameter(valid_589046, JInt, required = false, default = nil)
  if valid_589046 != nil:
    section.add "pageSize", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(true))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
  var valid_589048 = query.getOrDefault("filter")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "filter", valid_589048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589049: Call_CloudresourcemanagerProjectsList_589032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Projects that the caller has the `resourcemanager.projects.get`
  ## permission on and satisfy the specified filter.
  ## 
  ## This method returns Projects in an unspecified order.
  ## This method is eventually consistent with project mutations; this means
  ## that a newly created project may not appear in the results or recent
  ## updates to an existing project may not be reflected in the results. To
  ## retrieve the latest state of a project, use the
  ## GetProject method.
  ## 
  ## NOTE: If the request filter contains a `parent.type` and `parent.id` and
  ## the caller has the `resourcemanager.projects.list` permission on the
  ## parent, the results will be drawn from an alternate index which provides
  ## more consistent results. In future versions of this API, this List method
  ## will be split into List and Search to properly capture the behavorial
  ## difference.
  ## 
  let valid = call_589049.validator(path, query, header, formData, body)
  let scheme = call_589049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589049.url(scheme.get, call_589049.host, call_589049.base,
                         call_589049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589049, url, valid)

proc call*(call_589050: Call_CloudresourcemanagerProjectsList_589032;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudresourcemanagerProjectsList
  ## Lists Projects that the caller has the `resourcemanager.projects.get`
  ## permission on and satisfy the specified filter.
  ## 
  ## This method returns Projects in an unspecified order.
  ## This method is eventually consistent with project mutations; this means
  ## that a newly created project may not appear in the results or recent
  ## updates to an existing project may not be reflected in the results. To
  ## retrieve the latest state of a project, use the
  ## GetProject method.
  ## 
  ## NOTE: If the request filter contains a `parent.type` and `parent.id` and
  ## the caller has the `resourcemanager.projects.list` permission on the
  ## parent, the results will be drawn from an alternate index which provides
  ## more consistent results. In future versions of this API, this List method
  ## will be split into List and Search to properly capture the behavorial
  ## difference.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListProjects
  ## that indicates from where listing should continue.
  ## 
  ## Optional.
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
  ##   pageSize: int
  ##           : The maximum number of Projects to return in the response.
  ## The server can return fewer Projects than requested.
  ## If unspecified, server picks an appropriate default.
  ## 
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : An expression for filtering the results of the request.  Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ## + `name`
  ## + `id`
  ## + `labels.<key>` (where *key* is the name of a label)
  ## + `parent.type`
  ## + `parent.id`
  ## 
  ## Some examples of using labels as filters:
  ## 
  ## | Filter           | Description                                         |
  ## |------------------|-----------------------------------------------------|
  ## | name:how*        | The project's name starts with "how".               |
  ## | name:Howl        | The project's name is `Howl` or `howl`.             |
  ## | name:HOWL        | Equivalent to above.                                |
  ## | NAME:howl        | Equivalent to above.                                |
  ## | labels.color:*   | The project has the label `color`.                  |
  ## | labels.color:red | The project's label `color` has the value `red`.    |
  ## | labels.color:red&nbsp;labels.size:big |The project's label `color` has
  ##   the value `red` and its label `size` has the value `big`.              |
  ## 
  ## If no filter is specified, the call will return projects for which the user
  ## has the `resourcemanager.projects.get` permission.
  ## 
  ## NOTE: To perform a by-parent query (eg., what projects are directly in a
  ## Folder), the caller must have the `resourcemanager.projects.list`
  ## permission on the parent and the filter must contain both a `parent.type`
  ## and a `parent.id` restriction
  ## (example: "parent.type:folder parent.id:123"). In this case an alternate
  ## search index is used which provides more consistent results.
  ## 
  ## Optional.
  var query_589051 = newJObject()
  add(query_589051, "upload_protocol", newJString(uploadProtocol))
  add(query_589051, "fields", newJString(fields))
  add(query_589051, "pageToken", newJString(pageToken))
  add(query_589051, "quotaUser", newJString(quotaUser))
  add(query_589051, "alt", newJString(alt))
  add(query_589051, "oauth_token", newJString(oauthToken))
  add(query_589051, "callback", newJString(callback))
  add(query_589051, "access_token", newJString(accessToken))
  add(query_589051, "uploadType", newJString(uploadType))
  add(query_589051, "key", newJString(key))
  add(query_589051, "$.xgafv", newJString(Xgafv))
  add(query_589051, "pageSize", newJInt(pageSize))
  add(query_589051, "prettyPrint", newJBool(prettyPrint))
  add(query_589051, "filter", newJString(filter))
  result = call_589050.call(nil, query_589051, nil, nil, nil)

var cloudresourcemanagerProjectsList* = Call_CloudresourcemanagerProjectsList_589032(
    name: "cloudresourcemanagerProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/projects",
    validator: validate_CloudresourcemanagerProjectsList_589033, base: "/",
    url: url_CloudresourcemanagerProjectsList_589034, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUpdate_589104 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerProjectsUpdate_589106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsUpdate_589105(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project ID (for example, `my-project-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589107 = path.getOrDefault("projectId")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "projectId", valid_589107
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
  var valid_589108 = query.getOrDefault("upload_protocol")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "upload_protocol", valid_589108
  var valid_589109 = query.getOrDefault("fields")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "fields", valid_589109
  var valid_589110 = query.getOrDefault("quotaUser")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "quotaUser", valid_589110
  var valid_589111 = query.getOrDefault("alt")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("json"))
  if valid_589111 != nil:
    section.add "alt", valid_589111
  var valid_589112 = query.getOrDefault("oauth_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "oauth_token", valid_589112
  var valid_589113 = query.getOrDefault("callback")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "callback", valid_589113
  var valid_589114 = query.getOrDefault("access_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "access_token", valid_589114
  var valid_589115 = query.getOrDefault("uploadType")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "uploadType", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("$.xgafv")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("1"))
  if valid_589117 != nil:
    section.add "$.xgafv", valid_589117
  var valid_589118 = query.getOrDefault("prettyPrint")
  valid_589118 = validateParameter(valid_589118, JBool, required = false,
                                 default = newJBool(true))
  if valid_589118 != nil:
    section.add "prettyPrint", valid_589118
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

proc call*(call_589120: Call_CloudresourcemanagerProjectsUpdate_589104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_589120.validator(path, query, header, formData, body)
  let scheme = call_589120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589120.url(scheme.get, call_589120.host, call_589120.base,
                         call_589120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589120, url, valid)

proc call*(call_589121: Call_CloudresourcemanagerProjectsUpdate_589104;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsUpdate
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The project ID (for example, `my-project-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589122 = newJObject()
  var query_589123 = newJObject()
  var body_589124 = newJObject()
  add(query_589123, "upload_protocol", newJString(uploadProtocol))
  add(query_589123, "fields", newJString(fields))
  add(query_589123, "quotaUser", newJString(quotaUser))
  add(query_589123, "alt", newJString(alt))
  add(query_589123, "oauth_token", newJString(oauthToken))
  add(query_589123, "callback", newJString(callback))
  add(query_589123, "access_token", newJString(accessToken))
  add(query_589123, "uploadType", newJString(uploadType))
  add(query_589123, "key", newJString(key))
  add(path_589122, "projectId", newJString(projectId))
  add(query_589123, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589124 = body
  add(query_589123, "prettyPrint", newJBool(prettyPrint))
  result = call_589121.call(path_589122, query_589123, nil, nil, body_589124)

var cloudresourcemanagerProjectsUpdate* = Call_CloudresourcemanagerProjectsUpdate_589104(
    name: "cloudresourcemanagerProjectsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsUpdate_589105, base: "/",
    url: url_CloudresourcemanagerProjectsUpdate_589106, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGet_589071 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerProjectsGet_589073(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGet_589072(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589088 = path.getOrDefault("projectId")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "projectId", valid_589088
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
  var valid_589089 = query.getOrDefault("upload_protocol")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "upload_protocol", valid_589089
  var valid_589090 = query.getOrDefault("fields")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "fields", valid_589090
  var valid_589091 = query.getOrDefault("quotaUser")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "quotaUser", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("callback")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "callback", valid_589094
  var valid_589095 = query.getOrDefault("access_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "access_token", valid_589095
  var valid_589096 = query.getOrDefault("uploadType")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "uploadType", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("$.xgafv")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("1"))
  if valid_589098 != nil:
    section.add "$.xgafv", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589100: Call_CloudresourcemanagerProjectsGet_589071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_589100.validator(path, query, header, formData, body)
  let scheme = call_589100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589100.url(scheme.get, call_589100.host, call_589100.base,
                         call_589100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589100, url, valid)

proc call*(call_589101: Call_CloudresourcemanagerProjectsGet_589071;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsGet
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589102 = newJObject()
  var query_589103 = newJObject()
  add(query_589103, "upload_protocol", newJString(uploadProtocol))
  add(query_589103, "fields", newJString(fields))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(query_589103, "alt", newJString(alt))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "callback", newJString(callback))
  add(query_589103, "access_token", newJString(accessToken))
  add(query_589103, "uploadType", newJString(uploadType))
  add(query_589103, "key", newJString(key))
  add(path_589102, "projectId", newJString(projectId))
  add(query_589103, "$.xgafv", newJString(Xgafv))
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  result = call_589101.call(path_589102, query_589103, nil, nil, nil)

var cloudresourcemanagerProjectsGet* = Call_CloudresourcemanagerProjectsGet_589071(
    name: "cloudresourcemanagerProjectsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsGet_589072, base: "/",
    url: url_CloudresourcemanagerProjectsGet_589073, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsDelete_589125 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerProjectsDelete_589127(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsDelete_589126(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time,
  ## at which point the Project is no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject and
  ## ListProjects methods.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589128 = path.getOrDefault("projectId")
  valid_589128 = validateParameter(valid_589128, JString, required = true,
                                 default = nil)
  if valid_589128 != nil:
    section.add "projectId", valid_589128
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
  var valid_589129 = query.getOrDefault("upload_protocol")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "upload_protocol", valid_589129
  var valid_589130 = query.getOrDefault("fields")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "fields", valid_589130
  var valid_589131 = query.getOrDefault("quotaUser")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "quotaUser", valid_589131
  var valid_589132 = query.getOrDefault("alt")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("json"))
  if valid_589132 != nil:
    section.add "alt", valid_589132
  var valid_589133 = query.getOrDefault("oauth_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "oauth_token", valid_589133
  var valid_589134 = query.getOrDefault("callback")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "callback", valid_589134
  var valid_589135 = query.getOrDefault("access_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "access_token", valid_589135
  var valid_589136 = query.getOrDefault("uploadType")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "uploadType", valid_589136
  var valid_589137 = query.getOrDefault("key")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "key", valid_589137
  var valid_589138 = query.getOrDefault("$.xgafv")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = newJString("1"))
  if valid_589138 != nil:
    section.add "$.xgafv", valid_589138
  var valid_589139 = query.getOrDefault("prettyPrint")
  valid_589139 = validateParameter(valid_589139, JBool, required = false,
                                 default = newJBool(true))
  if valid_589139 != nil:
    section.add "prettyPrint", valid_589139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589140: Call_CloudresourcemanagerProjectsDelete_589125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time,
  ## at which point the Project is no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject and
  ## ListProjects methods.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_589140.validator(path, query, header, formData, body)
  let scheme = call_589140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589140.url(scheme.get, call_589140.host, call_589140.base,
                         call_589140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589140, url, valid)

proc call*(call_589141: Call_CloudresourcemanagerProjectsDelete_589125;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsDelete
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time,
  ## at which point the Project is no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject and
  ## ListProjects methods.
  ## 
  ## The caller must have modify permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The Project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589142 = newJObject()
  var query_589143 = newJObject()
  add(query_589143, "upload_protocol", newJString(uploadProtocol))
  add(query_589143, "fields", newJString(fields))
  add(query_589143, "quotaUser", newJString(quotaUser))
  add(query_589143, "alt", newJString(alt))
  add(query_589143, "oauth_token", newJString(oauthToken))
  add(query_589143, "callback", newJString(callback))
  add(query_589143, "access_token", newJString(accessToken))
  add(query_589143, "uploadType", newJString(uploadType))
  add(query_589143, "key", newJString(key))
  add(path_589142, "projectId", newJString(projectId))
  add(query_589143, "$.xgafv", newJString(Xgafv))
  add(query_589143, "prettyPrint", newJBool(prettyPrint))
  result = call_589141.call(path_589142, query_589143, nil, nil, nil)

var cloudresourcemanagerProjectsDelete* = Call_CloudresourcemanagerProjectsDelete_589125(
    name: "cloudresourcemanagerProjectsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsDelete_589126, base: "/",
    url: url_CloudresourcemanagerProjectsDelete_589127, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetAncestry_589144 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerProjectsGetAncestry_589146(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":getAncestry")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGetAncestry_589145(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589147 = path.getOrDefault("projectId")
  valid_589147 = validateParameter(valid_589147, JString, required = true,
                                 default = nil)
  if valid_589147 != nil:
    section.add "projectId", valid_589147
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
  var valid_589148 = query.getOrDefault("upload_protocol")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "upload_protocol", valid_589148
  var valid_589149 = query.getOrDefault("fields")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "fields", valid_589149
  var valid_589150 = query.getOrDefault("quotaUser")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "quotaUser", valid_589150
  var valid_589151 = query.getOrDefault("alt")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = newJString("json"))
  if valid_589151 != nil:
    section.add "alt", valid_589151
  var valid_589152 = query.getOrDefault("oauth_token")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "oauth_token", valid_589152
  var valid_589153 = query.getOrDefault("callback")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "callback", valid_589153
  var valid_589154 = query.getOrDefault("access_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "access_token", valid_589154
  var valid_589155 = query.getOrDefault("uploadType")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "uploadType", valid_589155
  var valid_589156 = query.getOrDefault("key")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "key", valid_589156
  var valid_589157 = query.getOrDefault("$.xgafv")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = newJString("1"))
  if valid_589157 != nil:
    section.add "$.xgafv", valid_589157
  var valid_589158 = query.getOrDefault("prettyPrint")
  valid_589158 = validateParameter(valid_589158, JBool, required = false,
                                 default = newJBool(true))
  if valid_589158 != nil:
    section.add "prettyPrint", valid_589158
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

proc call*(call_589160: Call_CloudresourcemanagerProjectsGetAncestry_589144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_589160.validator(path, query, header, formData, body)
  let scheme = call_589160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589160.url(scheme.get, call_589160.host, call_589160.base,
                         call_589160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589160, url, valid)

proc call*(call_589161: Call_CloudresourcemanagerProjectsGetAncestry_589144;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsGetAncestry
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589162 = newJObject()
  var query_589163 = newJObject()
  var body_589164 = newJObject()
  add(query_589163, "upload_protocol", newJString(uploadProtocol))
  add(query_589163, "fields", newJString(fields))
  add(query_589163, "quotaUser", newJString(quotaUser))
  add(query_589163, "alt", newJString(alt))
  add(query_589163, "oauth_token", newJString(oauthToken))
  add(query_589163, "callback", newJString(callback))
  add(query_589163, "access_token", newJString(accessToken))
  add(query_589163, "uploadType", newJString(uploadType))
  add(query_589163, "key", newJString(key))
  add(path_589162, "projectId", newJString(projectId))
  add(query_589163, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589164 = body
  add(query_589163, "prettyPrint", newJBool(prettyPrint))
  result = call_589161.call(path_589162, query_589163, nil, nil, body_589164)

var cloudresourcemanagerProjectsGetAncestry* = Call_CloudresourcemanagerProjectsGetAncestry_589144(
    name: "cloudresourcemanagerProjectsGetAncestry", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}:getAncestry",
    validator: validate_CloudresourcemanagerProjectsGetAncestry_589145, base: "/",
    url: url_CloudresourcemanagerProjectsGetAncestry_589146,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUndelete_589165 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerProjectsUndelete_589167(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsUndelete_589166(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## You can only use this method for a Project that has a lifecycle state of
  ## DELETE_REQUESTED.
  ## After deletion starts, the Project cannot be restored.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589168 = path.getOrDefault("projectId")
  valid_589168 = validateParameter(valid_589168, JString, required = true,
                                 default = nil)
  if valid_589168 != nil:
    section.add "projectId", valid_589168
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
  var valid_589169 = query.getOrDefault("upload_protocol")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "upload_protocol", valid_589169
  var valid_589170 = query.getOrDefault("fields")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "fields", valid_589170
  var valid_589171 = query.getOrDefault("quotaUser")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "quotaUser", valid_589171
  var valid_589172 = query.getOrDefault("alt")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = newJString("json"))
  if valid_589172 != nil:
    section.add "alt", valid_589172
  var valid_589173 = query.getOrDefault("oauth_token")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "oauth_token", valid_589173
  var valid_589174 = query.getOrDefault("callback")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "callback", valid_589174
  var valid_589175 = query.getOrDefault("access_token")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "access_token", valid_589175
  var valid_589176 = query.getOrDefault("uploadType")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "uploadType", valid_589176
  var valid_589177 = query.getOrDefault("key")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "key", valid_589177
  var valid_589178 = query.getOrDefault("$.xgafv")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = newJString("1"))
  if valid_589178 != nil:
    section.add "$.xgafv", valid_589178
  var valid_589179 = query.getOrDefault("prettyPrint")
  valid_589179 = validateParameter(valid_589179, JBool, required = false,
                                 default = newJBool(true))
  if valid_589179 != nil:
    section.add "prettyPrint", valid_589179
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

proc call*(call_589181: Call_CloudresourcemanagerProjectsUndelete_589165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restores the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## You can only use this method for a Project that has a lifecycle state of
  ## DELETE_REQUESTED.
  ## After deletion starts, the Project cannot be restored.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_589181.validator(path, query, header, formData, body)
  let scheme = call_589181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589181.url(scheme.get, call_589181.host, call_589181.base,
                         call_589181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589181, url, valid)

proc call*(call_589182: Call_CloudresourcemanagerProjectsUndelete_589165;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsUndelete
  ## Restores the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## You can only use this method for a Project that has a lifecycle state of
  ## DELETE_REQUESTED.
  ## After deletion starts, the Project cannot be restored.
  ## 
  ## The caller must have modify permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589183 = newJObject()
  var query_589184 = newJObject()
  var body_589185 = newJObject()
  add(query_589184, "upload_protocol", newJString(uploadProtocol))
  add(query_589184, "fields", newJString(fields))
  add(query_589184, "quotaUser", newJString(quotaUser))
  add(query_589184, "alt", newJString(alt))
  add(query_589184, "oauth_token", newJString(oauthToken))
  add(query_589184, "callback", newJString(callback))
  add(query_589184, "access_token", newJString(accessToken))
  add(query_589184, "uploadType", newJString(uploadType))
  add(query_589184, "key", newJString(key))
  add(path_589183, "projectId", newJString(projectId))
  add(query_589184, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589185 = body
  add(query_589184, "prettyPrint", newJBool(prettyPrint))
  result = call_589182.call(path_589183, query_589184, nil, nil, body_589185)

var cloudresourcemanagerProjectsUndelete* = Call_CloudresourcemanagerProjectsUndelete_589165(
    name: "cloudresourcemanagerProjectsUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}:undelete",
    validator: validate_CloudresourcemanagerProjectsUndelete_589166, base: "/",
    url: url_CloudresourcemanagerProjectsUndelete_589167, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetIamPolicy_589186 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerProjectsGetIamPolicy_589188(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGetIamPolicy_589187(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.getIamPolicy` on the project.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589189 = path.getOrDefault("resource")
  valid_589189 = validateParameter(valid_589189, JString, required = true,
                                 default = nil)
  if valid_589189 != nil:
    section.add "resource", valid_589189
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
  var valid_589190 = query.getOrDefault("upload_protocol")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "upload_protocol", valid_589190
  var valid_589191 = query.getOrDefault("fields")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "fields", valid_589191
  var valid_589192 = query.getOrDefault("quotaUser")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "quotaUser", valid_589192
  var valid_589193 = query.getOrDefault("alt")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = newJString("json"))
  if valid_589193 != nil:
    section.add "alt", valid_589193
  var valid_589194 = query.getOrDefault("oauth_token")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "oauth_token", valid_589194
  var valid_589195 = query.getOrDefault("callback")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "callback", valid_589195
  var valid_589196 = query.getOrDefault("access_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "access_token", valid_589196
  var valid_589197 = query.getOrDefault("uploadType")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "uploadType", valid_589197
  var valid_589198 = query.getOrDefault("key")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "key", valid_589198
  var valid_589199 = query.getOrDefault("$.xgafv")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = newJString("1"))
  if valid_589199 != nil:
    section.add "$.xgafv", valid_589199
  var valid_589200 = query.getOrDefault("prettyPrint")
  valid_589200 = validateParameter(valid_589200, JBool, required = false,
                                 default = newJBool(true))
  if valid_589200 != nil:
    section.add "prettyPrint", valid_589200
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

proc call*(call_589202: Call_CloudresourcemanagerProjectsGetIamPolicy_589186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.getIamPolicy` on the project.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
  ## 
  let valid = call_589202.validator(path, query, header, formData, body)
  let scheme = call_589202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589202.url(scheme.get, call_589202.host, call_589202.base,
                         call_589202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589202, url, valid)

proc call*(call_589203: Call_CloudresourcemanagerProjectsGetIamPolicy_589186;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsGetIamPolicy
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.getIamPolicy` on the project.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
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
  var path_589204 = newJObject()
  var query_589205 = newJObject()
  var body_589206 = newJObject()
  add(query_589205, "upload_protocol", newJString(uploadProtocol))
  add(query_589205, "fields", newJString(fields))
  add(query_589205, "quotaUser", newJString(quotaUser))
  add(query_589205, "alt", newJString(alt))
  add(query_589205, "oauth_token", newJString(oauthToken))
  add(query_589205, "callback", newJString(callback))
  add(query_589205, "access_token", newJString(accessToken))
  add(query_589205, "uploadType", newJString(uploadType))
  add(query_589205, "key", newJString(key))
  add(query_589205, "$.xgafv", newJString(Xgafv))
  add(path_589204, "resource", newJString(resource))
  if body != nil:
    body_589206 = body
  add(query_589205, "prettyPrint", newJBool(prettyPrint))
  result = call_589203.call(path_589204, query_589205, nil, nil, body_589206)

var cloudresourcemanagerProjectsGetIamPolicy* = Call_CloudresourcemanagerProjectsGetIamPolicy_589186(
    name: "cloudresourcemanagerProjectsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerProjectsGetIamPolicy_589187,
    base: "/", url: url_CloudresourcemanagerProjectsGetIamPolicy_589188,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsSetIamPolicy_589207 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerProjectsSetIamPolicy_589209(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsSetIamPolicy_589208(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the IAM access control policy for the specified Project. Overwrites
  ## any existing policy.
  ## 
  ## The following constraints apply when using `setIamPolicy()`:
  ## 
  ## + Project does not support `allUsers` and `allAuthenticatedUsers` as
  ## `members` in a `Binding` of a `Policy`.
  ## 
  ## + The owner role can be granted to a `user`, `serviceAccount`, or a group
  ## that is part of an organization. For example,
  ## group@myownpersonaldomain.com could be added as an owner to a project in
  ## the myownpersonaldomain.com organization, but not the examplepetstore.com
  ## organization.
  ## 
  ## + Service accounts can be made owners of a project directly
  ## without any restrictions. However, to be added as an owner, a user must be
  ## invited via Cloud Platform console and must accept the invitation.
  ## 
  ## + A user cannot be granted the owner role using `setIamPolicy()`. The user
  ## must be granted the owner role using the Cloud Platform Console and must
  ## explicitly accept the invitation.
  ## 
  ## + You can only grant ownership of a project to a member by using the
  ## GCP Console. Inviting a member will deliver an invitation email that
  ## they must accept. An invitation email is not generated if you are
  ## granting a role other than owner, or if both the member you are inviting
  ## and the project are part of your organization.
  ## 
  ## + Membership changes that leave the project without any owners that have
  ## accepted the Terms of Service (ToS) will be rejected.
  ## 
  ## + If the project is not part of an organization, there must be at least
  ## one owner who has accepted the Terms of Service (ToS) agreement in the
  ## policy. Calling `setIamPolicy()` to remove the last ToS-accepted owner
  ## from the policy will fail. This restriction also applies to legacy
  ## projects that no longer have owners who have accepted the ToS. Edits to
  ## IAM policies will be rejected until the lack of a ToS-accepting owner is
  ## rectified.
  ## 
  ## + This method will replace the existing policy, and cannot be used to
  ## append additional IAM settings.
  ## 
  ## Note: Removing service accounts from policies or changing their roles
  ## can render services completely inoperable. It is important to understand
  ## how the service account is being used before removing or updating its
  ## roles.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.setIamPolicy` on the project
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589210 = path.getOrDefault("resource")
  valid_589210 = validateParameter(valid_589210, JString, required = true,
                                 default = nil)
  if valid_589210 != nil:
    section.add "resource", valid_589210
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
  var valid_589211 = query.getOrDefault("upload_protocol")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "upload_protocol", valid_589211
  var valid_589212 = query.getOrDefault("fields")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "fields", valid_589212
  var valid_589213 = query.getOrDefault("quotaUser")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "quotaUser", valid_589213
  var valid_589214 = query.getOrDefault("alt")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = newJString("json"))
  if valid_589214 != nil:
    section.add "alt", valid_589214
  var valid_589215 = query.getOrDefault("oauth_token")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "oauth_token", valid_589215
  var valid_589216 = query.getOrDefault("callback")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "callback", valid_589216
  var valid_589217 = query.getOrDefault("access_token")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "access_token", valid_589217
  var valid_589218 = query.getOrDefault("uploadType")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "uploadType", valid_589218
  var valid_589219 = query.getOrDefault("key")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "key", valid_589219
  var valid_589220 = query.getOrDefault("$.xgafv")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = newJString("1"))
  if valid_589220 != nil:
    section.add "$.xgafv", valid_589220
  var valid_589221 = query.getOrDefault("prettyPrint")
  valid_589221 = validateParameter(valid_589221, JBool, required = false,
                                 default = newJBool(true))
  if valid_589221 != nil:
    section.add "prettyPrint", valid_589221
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

proc call*(call_589223: Call_CloudresourcemanagerProjectsSetIamPolicy_589207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM access control policy for the specified Project. Overwrites
  ## any existing policy.
  ## 
  ## The following constraints apply when using `setIamPolicy()`:
  ## 
  ## + Project does not support `allUsers` and `allAuthenticatedUsers` as
  ## `members` in a `Binding` of a `Policy`.
  ## 
  ## + The owner role can be granted to a `user`, `serviceAccount`, or a group
  ## that is part of an organization. For example,
  ## group@myownpersonaldomain.com could be added as an owner to a project in
  ## the myownpersonaldomain.com organization, but not the examplepetstore.com
  ## organization.
  ## 
  ## + Service accounts can be made owners of a project directly
  ## without any restrictions. However, to be added as an owner, a user must be
  ## invited via Cloud Platform console and must accept the invitation.
  ## 
  ## + A user cannot be granted the owner role using `setIamPolicy()`. The user
  ## must be granted the owner role using the Cloud Platform Console and must
  ## explicitly accept the invitation.
  ## 
  ## + You can only grant ownership of a project to a member by using the
  ## GCP Console. Inviting a member will deliver an invitation email that
  ## they must accept. An invitation email is not generated if you are
  ## granting a role other than owner, or if both the member you are inviting
  ## and the project are part of your organization.
  ## 
  ## + Membership changes that leave the project without any owners that have
  ## accepted the Terms of Service (ToS) will be rejected.
  ## 
  ## + If the project is not part of an organization, there must be at least
  ## one owner who has accepted the Terms of Service (ToS) agreement in the
  ## policy. Calling `setIamPolicy()` to remove the last ToS-accepted owner
  ## from the policy will fail. This restriction also applies to legacy
  ## projects that no longer have owners who have accepted the ToS. Edits to
  ## IAM policies will be rejected until the lack of a ToS-accepting owner is
  ## rectified.
  ## 
  ## + This method will replace the existing policy, and cannot be used to
  ## append additional IAM settings.
  ## 
  ## Note: Removing service accounts from policies or changing their roles
  ## can render services completely inoperable. It is important to understand
  ## how the service account is being used before removing or updating its
  ## roles.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.setIamPolicy` on the project
  ## 
  let valid = call_589223.validator(path, query, header, formData, body)
  let scheme = call_589223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589223.url(scheme.get, call_589223.host, call_589223.base,
                         call_589223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589223, url, valid)

proc call*(call_589224: Call_CloudresourcemanagerProjectsSetIamPolicy_589207;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsSetIamPolicy
  ## Sets the IAM access control policy for the specified Project. Overwrites
  ## any existing policy.
  ## 
  ## The following constraints apply when using `setIamPolicy()`:
  ## 
  ## + Project does not support `allUsers` and `allAuthenticatedUsers` as
  ## `members` in a `Binding` of a `Policy`.
  ## 
  ## + The owner role can be granted to a `user`, `serviceAccount`, or a group
  ## that is part of an organization. For example,
  ## group@myownpersonaldomain.com could be added as an owner to a project in
  ## the myownpersonaldomain.com organization, but not the examplepetstore.com
  ## organization.
  ## 
  ## + Service accounts can be made owners of a project directly
  ## without any restrictions. However, to be added as an owner, a user must be
  ## invited via Cloud Platform console and must accept the invitation.
  ## 
  ## + A user cannot be granted the owner role using `setIamPolicy()`. The user
  ## must be granted the owner role using the Cloud Platform Console and must
  ## explicitly accept the invitation.
  ## 
  ## + You can only grant ownership of a project to a member by using the
  ## GCP Console. Inviting a member will deliver an invitation email that
  ## they must accept. An invitation email is not generated if you are
  ## granting a role other than owner, or if both the member you are inviting
  ## and the project are part of your organization.
  ## 
  ## + Membership changes that leave the project without any owners that have
  ## accepted the Terms of Service (ToS) will be rejected.
  ## 
  ## + If the project is not part of an organization, there must be at least
  ## one owner who has accepted the Terms of Service (ToS) agreement in the
  ## policy. Calling `setIamPolicy()` to remove the last ToS-accepted owner
  ## from the policy will fail. This restriction also applies to legacy
  ## projects that no longer have owners who have accepted the ToS. Edits to
  ## IAM policies will be rejected until the lack of a ToS-accepting owner is
  ## rectified.
  ## 
  ## + This method will replace the existing policy, and cannot be used to
  ## append additional IAM settings.
  ## 
  ## Note: Removing service accounts from policies or changing their roles
  ## can render services completely inoperable. It is important to understand
  ## how the service account is being used before removing or updating its
  ## roles.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.setIamPolicy` on the project
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
  var path_589225 = newJObject()
  var query_589226 = newJObject()
  var body_589227 = newJObject()
  add(query_589226, "upload_protocol", newJString(uploadProtocol))
  add(query_589226, "fields", newJString(fields))
  add(query_589226, "quotaUser", newJString(quotaUser))
  add(query_589226, "alt", newJString(alt))
  add(query_589226, "oauth_token", newJString(oauthToken))
  add(query_589226, "callback", newJString(callback))
  add(query_589226, "access_token", newJString(accessToken))
  add(query_589226, "uploadType", newJString(uploadType))
  add(query_589226, "key", newJString(key))
  add(query_589226, "$.xgafv", newJString(Xgafv))
  add(path_589225, "resource", newJString(resource))
  if body != nil:
    body_589227 = body
  add(query_589226, "prettyPrint", newJBool(prettyPrint))
  result = call_589224.call(path_589225, query_589226, nil, nil, body_589227)

var cloudresourcemanagerProjectsSetIamPolicy* = Call_CloudresourcemanagerProjectsSetIamPolicy_589207(
    name: "cloudresourcemanagerProjectsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerProjectsSetIamPolicy_589208,
    base: "/", url: url_CloudresourcemanagerProjectsSetIamPolicy_589209,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsTestIamPermissions_589228 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerProjectsTestIamPermissions_589230(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsTestIamPermissions_589229(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Project.
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
  var valid_589231 = path.getOrDefault("resource")
  valid_589231 = validateParameter(valid_589231, JString, required = true,
                                 default = nil)
  if valid_589231 != nil:
    section.add "resource", valid_589231
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
  var valid_589232 = query.getOrDefault("upload_protocol")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "upload_protocol", valid_589232
  var valid_589233 = query.getOrDefault("fields")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "fields", valid_589233
  var valid_589234 = query.getOrDefault("quotaUser")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "quotaUser", valid_589234
  var valid_589235 = query.getOrDefault("alt")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("json"))
  if valid_589235 != nil:
    section.add "alt", valid_589235
  var valid_589236 = query.getOrDefault("oauth_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "oauth_token", valid_589236
  var valid_589237 = query.getOrDefault("callback")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "callback", valid_589237
  var valid_589238 = query.getOrDefault("access_token")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "access_token", valid_589238
  var valid_589239 = query.getOrDefault("uploadType")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "uploadType", valid_589239
  var valid_589240 = query.getOrDefault("key")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "key", valid_589240
  var valid_589241 = query.getOrDefault("$.xgafv")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = newJString("1"))
  if valid_589241 != nil:
    section.add "$.xgafv", valid_589241
  var valid_589242 = query.getOrDefault("prettyPrint")
  valid_589242 = validateParameter(valid_589242, JBool, required = false,
                                 default = newJBool(true))
  if valid_589242 != nil:
    section.add "prettyPrint", valid_589242
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

proc call*(call_589244: Call_CloudresourcemanagerProjectsTestIamPermissions_589228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_589244.validator(path, query, header, formData, body)
  let scheme = call_589244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589244.url(scheme.get, call_589244.host, call_589244.base,
                         call_589244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589244, url, valid)

proc call*(call_589245: Call_CloudresourcemanagerProjectsTestIamPermissions_589228;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsTestIamPermissions
  ## Returns permissions that a caller has on the specified Project.
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
  var path_589246 = newJObject()
  var query_589247 = newJObject()
  var body_589248 = newJObject()
  add(query_589247, "upload_protocol", newJString(uploadProtocol))
  add(query_589247, "fields", newJString(fields))
  add(query_589247, "quotaUser", newJString(quotaUser))
  add(query_589247, "alt", newJString(alt))
  add(query_589247, "oauth_token", newJString(oauthToken))
  add(query_589247, "callback", newJString(callback))
  add(query_589247, "access_token", newJString(accessToken))
  add(query_589247, "uploadType", newJString(uploadType))
  add(query_589247, "key", newJString(key))
  add(query_589247, "$.xgafv", newJString(Xgafv))
  add(path_589246, "resource", newJString(resource))
  if body != nil:
    body_589248 = body
  add(query_589247, "prettyPrint", newJBool(prettyPrint))
  result = call_589245.call(path_589246, query_589247, nil, nil, body_589248)

var cloudresourcemanagerProjectsTestIamPermissions* = Call_CloudresourcemanagerProjectsTestIamPermissions_589228(
    name: "cloudresourcemanagerProjectsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerProjectsTestIamPermissions_589229,
    base: "/", url: url_CloudresourcemanagerProjectsTestIamPermissions_589230,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGet_589249 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsGet_589251(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudresourcemanagerOrganizationsGet_589250(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches an Organization resource identified by the specified resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the Organization to fetch. This is the organization's
  ## relative path in the API, formatted as "organizations/[organizationId]".
  ## For example, "organizations/1234".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589252 = path.getOrDefault("name")
  valid_589252 = validateParameter(valid_589252, JString, required = true,
                                 default = nil)
  if valid_589252 != nil:
    section.add "name", valid_589252
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
  var valid_589253 = query.getOrDefault("upload_protocol")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "upload_protocol", valid_589253
  var valid_589254 = query.getOrDefault("fields")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "fields", valid_589254
  var valid_589255 = query.getOrDefault("quotaUser")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "quotaUser", valid_589255
  var valid_589256 = query.getOrDefault("alt")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = newJString("json"))
  if valid_589256 != nil:
    section.add "alt", valid_589256
  var valid_589257 = query.getOrDefault("oauth_token")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "oauth_token", valid_589257
  var valid_589258 = query.getOrDefault("callback")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "callback", valid_589258
  var valid_589259 = query.getOrDefault("access_token")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "access_token", valid_589259
  var valid_589260 = query.getOrDefault("uploadType")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "uploadType", valid_589260
  var valid_589261 = query.getOrDefault("key")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "key", valid_589261
  var valid_589262 = query.getOrDefault("$.xgafv")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = newJString("1"))
  if valid_589262 != nil:
    section.add "$.xgafv", valid_589262
  var valid_589263 = query.getOrDefault("prettyPrint")
  valid_589263 = validateParameter(valid_589263, JBool, required = false,
                                 default = newJBool(true))
  if valid_589263 != nil:
    section.add "prettyPrint", valid_589263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589264: Call_CloudresourcemanagerOrganizationsGet_589249;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches an Organization resource identified by the specified resource name.
  ## 
  let valid = call_589264.validator(path, query, header, formData, body)
  let scheme = call_589264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589264.url(scheme.get, call_589264.host, call_589264.base,
                         call_589264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589264, url, valid)

proc call*(call_589265: Call_CloudresourcemanagerOrganizationsGet_589249;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsGet
  ## Fetches an Organization resource identified by the specified resource name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the Organization to fetch. This is the organization's
  ## relative path in the API, formatted as "organizations/[organizationId]".
  ## For example, "organizations/1234".
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
  var path_589266 = newJObject()
  var query_589267 = newJObject()
  add(query_589267, "upload_protocol", newJString(uploadProtocol))
  add(query_589267, "fields", newJString(fields))
  add(query_589267, "quotaUser", newJString(quotaUser))
  add(path_589266, "name", newJString(name))
  add(query_589267, "alt", newJString(alt))
  add(query_589267, "oauth_token", newJString(oauthToken))
  add(query_589267, "callback", newJString(callback))
  add(query_589267, "access_token", newJString(accessToken))
  add(query_589267, "uploadType", newJString(uploadType))
  add(query_589267, "key", newJString(key))
  add(query_589267, "$.xgafv", newJString(Xgafv))
  add(query_589267, "prettyPrint", newJBool(prettyPrint))
  result = call_589265.call(path_589266, query_589267, nil, nil, nil)

var cloudresourcemanagerOrganizationsGet* = Call_CloudresourcemanagerOrganizationsGet_589249(
    name: "cloudresourcemanagerOrganizationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerOrganizationsGet_589250, base: "/",
    url: url_CloudresourcemanagerOrganizationsGet_589251, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerLiensDelete_589268 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerLiensDelete_589270(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerLiensDelete_589269(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Lien by `name`.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name/identifier of the Lien to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589271 = path.getOrDefault("name")
  valid_589271 = validateParameter(valid_589271, JString, required = true,
                                 default = nil)
  if valid_589271 != nil:
    section.add "name", valid_589271
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
  var valid_589272 = query.getOrDefault("upload_protocol")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "upload_protocol", valid_589272
  var valid_589273 = query.getOrDefault("fields")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "fields", valid_589273
  var valid_589274 = query.getOrDefault("quotaUser")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "quotaUser", valid_589274
  var valid_589275 = query.getOrDefault("alt")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = newJString("json"))
  if valid_589275 != nil:
    section.add "alt", valid_589275
  var valid_589276 = query.getOrDefault("oauth_token")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "oauth_token", valid_589276
  var valid_589277 = query.getOrDefault("callback")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "callback", valid_589277
  var valid_589278 = query.getOrDefault("access_token")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "access_token", valid_589278
  var valid_589279 = query.getOrDefault("uploadType")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "uploadType", valid_589279
  var valid_589280 = query.getOrDefault("key")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "key", valid_589280
  var valid_589281 = query.getOrDefault("$.xgafv")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = newJString("1"))
  if valid_589281 != nil:
    section.add "$.xgafv", valid_589281
  var valid_589282 = query.getOrDefault("prettyPrint")
  valid_589282 = validateParameter(valid_589282, JBool, required = false,
                                 default = newJBool(true))
  if valid_589282 != nil:
    section.add "prettyPrint", valid_589282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589283: Call_CloudresourcemanagerLiensDelete_589268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a Lien by `name`.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  let valid = call_589283.validator(path, query, header, formData, body)
  let scheme = call_589283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589283.url(scheme.get, call_589283.host, call_589283.base,
                         call_589283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589283, url, valid)

proc call*(call_589284: Call_CloudresourcemanagerLiensDelete_589268; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerLiensDelete
  ## Delete a Lien by `name`.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name/identifier of the Lien to delete.
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
  var path_589285 = newJObject()
  var query_589286 = newJObject()
  add(query_589286, "upload_protocol", newJString(uploadProtocol))
  add(query_589286, "fields", newJString(fields))
  add(query_589286, "quotaUser", newJString(quotaUser))
  add(path_589285, "name", newJString(name))
  add(query_589286, "alt", newJString(alt))
  add(query_589286, "oauth_token", newJString(oauthToken))
  add(query_589286, "callback", newJString(callback))
  add(query_589286, "access_token", newJString(accessToken))
  add(query_589286, "uploadType", newJString(uploadType))
  add(query_589286, "key", newJString(key))
  add(query_589286, "$.xgafv", newJString(Xgafv))
  add(query_589286, "prettyPrint", newJBool(prettyPrint))
  result = call_589284.call(path_589285, query_589286, nil, nil, nil)

var cloudresourcemanagerLiensDelete* = Call_CloudresourcemanagerLiensDelete_589268(
    name: "cloudresourcemanagerLiensDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerLiensDelete_589269, base: "/",
    url: url_CloudresourcemanagerLiensDelete_589270, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsClearOrgPolicy_589287 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsClearOrgPolicy_589289(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":clearOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsClearOrgPolicy_589288(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Clears a `Policy` from a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource for the `Policy` to clear.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589290 = path.getOrDefault("resource")
  valid_589290 = validateParameter(valid_589290, JString, required = true,
                                 default = nil)
  if valid_589290 != nil:
    section.add "resource", valid_589290
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
  var valid_589291 = query.getOrDefault("upload_protocol")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "upload_protocol", valid_589291
  var valid_589292 = query.getOrDefault("fields")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "fields", valid_589292
  var valid_589293 = query.getOrDefault("quotaUser")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "quotaUser", valid_589293
  var valid_589294 = query.getOrDefault("alt")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = newJString("json"))
  if valid_589294 != nil:
    section.add "alt", valid_589294
  var valid_589295 = query.getOrDefault("oauth_token")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "oauth_token", valid_589295
  var valid_589296 = query.getOrDefault("callback")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "callback", valid_589296
  var valid_589297 = query.getOrDefault("access_token")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "access_token", valid_589297
  var valid_589298 = query.getOrDefault("uploadType")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "uploadType", valid_589298
  var valid_589299 = query.getOrDefault("key")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "key", valid_589299
  var valid_589300 = query.getOrDefault("$.xgafv")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = newJString("1"))
  if valid_589300 != nil:
    section.add "$.xgafv", valid_589300
  var valid_589301 = query.getOrDefault("prettyPrint")
  valid_589301 = validateParameter(valid_589301, JBool, required = false,
                                 default = newJBool(true))
  if valid_589301 != nil:
    section.add "prettyPrint", valid_589301
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

proc call*(call_589303: Call_CloudresourcemanagerOrganizationsClearOrgPolicy_589287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears a `Policy` from a resource.
  ## 
  let valid = call_589303.validator(path, query, header, formData, body)
  let scheme = call_589303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589303.url(scheme.get, call_589303.host, call_589303.base,
                         call_589303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589303, url, valid)

proc call*(call_589304: Call_CloudresourcemanagerOrganizationsClearOrgPolicy_589287;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsClearOrgPolicy
  ## Clears a `Policy` from a resource.
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
  ##           : Name of the resource for the `Policy` to clear.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589305 = newJObject()
  var query_589306 = newJObject()
  var body_589307 = newJObject()
  add(query_589306, "upload_protocol", newJString(uploadProtocol))
  add(query_589306, "fields", newJString(fields))
  add(query_589306, "quotaUser", newJString(quotaUser))
  add(query_589306, "alt", newJString(alt))
  add(query_589306, "oauth_token", newJString(oauthToken))
  add(query_589306, "callback", newJString(callback))
  add(query_589306, "access_token", newJString(accessToken))
  add(query_589306, "uploadType", newJString(uploadType))
  add(query_589306, "key", newJString(key))
  add(query_589306, "$.xgafv", newJString(Xgafv))
  add(path_589305, "resource", newJString(resource))
  if body != nil:
    body_589307 = body
  add(query_589306, "prettyPrint", newJBool(prettyPrint))
  result = call_589304.call(path_589305, query_589306, nil, nil, body_589307)

var cloudresourcemanagerOrganizationsClearOrgPolicy* = Call_CloudresourcemanagerOrganizationsClearOrgPolicy_589287(
    name: "cloudresourcemanagerOrganizationsClearOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:clearOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsClearOrgPolicy_589288,
    base: "/", url: url_CloudresourcemanagerOrganizationsClearOrgPolicy_589289,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_589308 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_589310(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getEffectiveOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_589309(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the effective `Policy` on a resource. This is the result of merging
  ## `Policies` in the resource hierarchy. The returned `Policy` will not have
  ## an `etag`set because it is a computed `Policy` across multiple resources.
  ## Subtrees of Resource Manager resource hierarchy with 'under:' prefix will
  ## not be expanded.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : The name of the resource to start computing the effective `Policy`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589311 = path.getOrDefault("resource")
  valid_589311 = validateParameter(valid_589311, JString, required = true,
                                 default = nil)
  if valid_589311 != nil:
    section.add "resource", valid_589311
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
  var valid_589312 = query.getOrDefault("upload_protocol")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "upload_protocol", valid_589312
  var valid_589313 = query.getOrDefault("fields")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "fields", valid_589313
  var valid_589314 = query.getOrDefault("quotaUser")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "quotaUser", valid_589314
  var valid_589315 = query.getOrDefault("alt")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = newJString("json"))
  if valid_589315 != nil:
    section.add "alt", valid_589315
  var valid_589316 = query.getOrDefault("oauth_token")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "oauth_token", valid_589316
  var valid_589317 = query.getOrDefault("callback")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "callback", valid_589317
  var valid_589318 = query.getOrDefault("access_token")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "access_token", valid_589318
  var valid_589319 = query.getOrDefault("uploadType")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "uploadType", valid_589319
  var valid_589320 = query.getOrDefault("key")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "key", valid_589320
  var valid_589321 = query.getOrDefault("$.xgafv")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("1"))
  if valid_589321 != nil:
    section.add "$.xgafv", valid_589321
  var valid_589322 = query.getOrDefault("prettyPrint")
  valid_589322 = validateParameter(valid_589322, JBool, required = false,
                                 default = newJBool(true))
  if valid_589322 != nil:
    section.add "prettyPrint", valid_589322
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

proc call*(call_589324: Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_589308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the effective `Policy` on a resource. This is the result of merging
  ## `Policies` in the resource hierarchy. The returned `Policy` will not have
  ## an `etag`set because it is a computed `Policy` across multiple resources.
  ## Subtrees of Resource Manager resource hierarchy with 'under:' prefix will
  ## not be expanded.
  ## 
  let valid = call_589324.validator(path, query, header, formData, body)
  let scheme = call_589324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589324.url(scheme.get, call_589324.host, call_589324.base,
                         call_589324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589324, url, valid)

proc call*(call_589325: Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_589308;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy
  ## Gets the effective `Policy` on a resource. This is the result of merging
  ## `Policies` in the resource hierarchy. The returned `Policy` will not have
  ## an `etag`set because it is a computed `Policy` across multiple resources.
  ## Subtrees of Resource Manager resource hierarchy with 'under:' prefix will
  ## not be expanded.
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
  ##           : The name of the resource to start computing the effective `Policy`.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589326 = newJObject()
  var query_589327 = newJObject()
  var body_589328 = newJObject()
  add(query_589327, "upload_protocol", newJString(uploadProtocol))
  add(query_589327, "fields", newJString(fields))
  add(query_589327, "quotaUser", newJString(quotaUser))
  add(query_589327, "alt", newJString(alt))
  add(query_589327, "oauth_token", newJString(oauthToken))
  add(query_589327, "callback", newJString(callback))
  add(query_589327, "access_token", newJString(accessToken))
  add(query_589327, "uploadType", newJString(uploadType))
  add(query_589327, "key", newJString(key))
  add(query_589327, "$.xgafv", newJString(Xgafv))
  add(path_589326, "resource", newJString(resource))
  if body != nil:
    body_589328 = body
  add(query_589327, "prettyPrint", newJBool(prettyPrint))
  result = call_589325.call(path_589326, query_589327, nil, nil, body_589328)

var cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy* = Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_589308(
    name: "cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getEffectiveOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_589309,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_589310,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetIamPolicy_589329 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsGetIamPolicy_589331(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGetIamPolicy_589330(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.getIamPolicy` on the specified organization
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589332 = path.getOrDefault("resource")
  valid_589332 = validateParameter(valid_589332, JString, required = true,
                                 default = nil)
  if valid_589332 != nil:
    section.add "resource", valid_589332
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
  var valid_589333 = query.getOrDefault("upload_protocol")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "upload_protocol", valid_589333
  var valid_589334 = query.getOrDefault("fields")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "fields", valid_589334
  var valid_589335 = query.getOrDefault("quotaUser")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "quotaUser", valid_589335
  var valid_589336 = query.getOrDefault("alt")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = newJString("json"))
  if valid_589336 != nil:
    section.add "alt", valid_589336
  var valid_589337 = query.getOrDefault("oauth_token")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "oauth_token", valid_589337
  var valid_589338 = query.getOrDefault("callback")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "callback", valid_589338
  var valid_589339 = query.getOrDefault("access_token")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "access_token", valid_589339
  var valid_589340 = query.getOrDefault("uploadType")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "uploadType", valid_589340
  var valid_589341 = query.getOrDefault("key")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "key", valid_589341
  var valid_589342 = query.getOrDefault("$.xgafv")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = newJString("1"))
  if valid_589342 != nil:
    section.add "$.xgafv", valid_589342
  var valid_589343 = query.getOrDefault("prettyPrint")
  valid_589343 = validateParameter(valid_589343, JBool, required = false,
                                 default = newJBool(true))
  if valid_589343 != nil:
    section.add "prettyPrint", valid_589343
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

proc call*(call_589345: Call_CloudresourcemanagerOrganizationsGetIamPolicy_589329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.getIamPolicy` on the specified organization
  ## 
  let valid = call_589345.validator(path, query, header, formData, body)
  let scheme = call_589345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589345.url(scheme.get, call_589345.host, call_589345.base,
                         call_589345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589345, url, valid)

proc call*(call_589346: Call_CloudresourcemanagerOrganizationsGetIamPolicy_589329;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsGetIamPolicy
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.getIamPolicy` on the specified organization
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
  var path_589347 = newJObject()
  var query_589348 = newJObject()
  var body_589349 = newJObject()
  add(query_589348, "upload_protocol", newJString(uploadProtocol))
  add(query_589348, "fields", newJString(fields))
  add(query_589348, "quotaUser", newJString(quotaUser))
  add(query_589348, "alt", newJString(alt))
  add(query_589348, "oauth_token", newJString(oauthToken))
  add(query_589348, "callback", newJString(callback))
  add(query_589348, "access_token", newJString(accessToken))
  add(query_589348, "uploadType", newJString(uploadType))
  add(query_589348, "key", newJString(key))
  add(query_589348, "$.xgafv", newJString(Xgafv))
  add(path_589347, "resource", newJString(resource))
  if body != nil:
    body_589349 = body
  add(query_589348, "prettyPrint", newJBool(prettyPrint))
  result = call_589346.call(path_589347, query_589348, nil, nil, body_589349)

var cloudresourcemanagerOrganizationsGetIamPolicy* = Call_CloudresourcemanagerOrganizationsGetIamPolicy_589329(
    name: "cloudresourcemanagerOrganizationsGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetIamPolicy_589330,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetIamPolicy_589331,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetOrgPolicy_589350 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsGetOrgPolicy_589352(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGetOrgPolicy_589351(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a `Policy` on a resource.
  ## 
  ## If no `Policy` is set on the resource, a `Policy` is returned with default
  ## values including `POLICY_TYPE_NOT_SET` for the `policy_type oneof`. The
  ## `etag` value can be used with `SetOrgPolicy()` to create or update a
  ## `Policy` during read-modify-write.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource the `Policy` is set on.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589353 = path.getOrDefault("resource")
  valid_589353 = validateParameter(valid_589353, JString, required = true,
                                 default = nil)
  if valid_589353 != nil:
    section.add "resource", valid_589353
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
  var valid_589354 = query.getOrDefault("upload_protocol")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "upload_protocol", valid_589354
  var valid_589355 = query.getOrDefault("fields")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "fields", valid_589355
  var valid_589356 = query.getOrDefault("quotaUser")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "quotaUser", valid_589356
  var valid_589357 = query.getOrDefault("alt")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = newJString("json"))
  if valid_589357 != nil:
    section.add "alt", valid_589357
  var valid_589358 = query.getOrDefault("oauth_token")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "oauth_token", valid_589358
  var valid_589359 = query.getOrDefault("callback")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "callback", valid_589359
  var valid_589360 = query.getOrDefault("access_token")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "access_token", valid_589360
  var valid_589361 = query.getOrDefault("uploadType")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "uploadType", valid_589361
  var valid_589362 = query.getOrDefault("key")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "key", valid_589362
  var valid_589363 = query.getOrDefault("$.xgafv")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = newJString("1"))
  if valid_589363 != nil:
    section.add "$.xgafv", valid_589363
  var valid_589364 = query.getOrDefault("prettyPrint")
  valid_589364 = validateParameter(valid_589364, JBool, required = false,
                                 default = newJBool(true))
  if valid_589364 != nil:
    section.add "prettyPrint", valid_589364
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

proc call*(call_589366: Call_CloudresourcemanagerOrganizationsGetOrgPolicy_589350;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a `Policy` on a resource.
  ## 
  ## If no `Policy` is set on the resource, a `Policy` is returned with default
  ## values including `POLICY_TYPE_NOT_SET` for the `policy_type oneof`. The
  ## `etag` value can be used with `SetOrgPolicy()` to create or update a
  ## `Policy` during read-modify-write.
  ## 
  let valid = call_589366.validator(path, query, header, formData, body)
  let scheme = call_589366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589366.url(scheme.get, call_589366.host, call_589366.base,
                         call_589366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589366, url, valid)

proc call*(call_589367: Call_CloudresourcemanagerOrganizationsGetOrgPolicy_589350;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsGetOrgPolicy
  ## Gets a `Policy` on a resource.
  ## 
  ## If no `Policy` is set on the resource, a `Policy` is returned with default
  ## values including `POLICY_TYPE_NOT_SET` for the `policy_type oneof`. The
  ## `etag` value can be used with `SetOrgPolicy()` to create or update a
  ## `Policy` during read-modify-write.
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
  ##           : Name of the resource the `Policy` is set on.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589368 = newJObject()
  var query_589369 = newJObject()
  var body_589370 = newJObject()
  add(query_589369, "upload_protocol", newJString(uploadProtocol))
  add(query_589369, "fields", newJString(fields))
  add(query_589369, "quotaUser", newJString(quotaUser))
  add(query_589369, "alt", newJString(alt))
  add(query_589369, "oauth_token", newJString(oauthToken))
  add(query_589369, "callback", newJString(callback))
  add(query_589369, "access_token", newJString(accessToken))
  add(query_589369, "uploadType", newJString(uploadType))
  add(query_589369, "key", newJString(key))
  add(query_589369, "$.xgafv", newJString(Xgafv))
  add(path_589368, "resource", newJString(resource))
  if body != nil:
    body_589370 = body
  add(query_589369, "prettyPrint", newJBool(prettyPrint))
  result = call_589367.call(path_589368, query_589369, nil, nil, body_589370)

var cloudresourcemanagerOrganizationsGetOrgPolicy* = Call_CloudresourcemanagerOrganizationsGetOrgPolicy_589350(
    name: "cloudresourcemanagerOrganizationsGetOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetOrgPolicy_589351,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetOrgPolicy_589352,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_589371 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_589373(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"), (kind: ConstantSegment,
        value: ":listAvailableOrgPolicyConstraints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_589372(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists `Constraints` that could be applied on the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource to list `Constraints` for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589374 = path.getOrDefault("resource")
  valid_589374 = validateParameter(valid_589374, JString, required = true,
                                 default = nil)
  if valid_589374 != nil:
    section.add "resource", valid_589374
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
  var valid_589375 = query.getOrDefault("upload_protocol")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "upload_protocol", valid_589375
  var valid_589376 = query.getOrDefault("fields")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "fields", valid_589376
  var valid_589377 = query.getOrDefault("quotaUser")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "quotaUser", valid_589377
  var valid_589378 = query.getOrDefault("alt")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = newJString("json"))
  if valid_589378 != nil:
    section.add "alt", valid_589378
  var valid_589379 = query.getOrDefault("oauth_token")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "oauth_token", valid_589379
  var valid_589380 = query.getOrDefault("callback")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "callback", valid_589380
  var valid_589381 = query.getOrDefault("access_token")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "access_token", valid_589381
  var valid_589382 = query.getOrDefault("uploadType")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "uploadType", valid_589382
  var valid_589383 = query.getOrDefault("key")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "key", valid_589383
  var valid_589384 = query.getOrDefault("$.xgafv")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = newJString("1"))
  if valid_589384 != nil:
    section.add "$.xgafv", valid_589384
  var valid_589385 = query.getOrDefault("prettyPrint")
  valid_589385 = validateParameter(valid_589385, JBool, required = false,
                                 default = newJBool(true))
  if valid_589385 != nil:
    section.add "prettyPrint", valid_589385
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

proc call*(call_589387: Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_589371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists `Constraints` that could be applied on the specified resource.
  ## 
  let valid = call_589387.validator(path, query, header, formData, body)
  let scheme = call_589387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589387.url(scheme.get, call_589387.host, call_589387.base,
                         call_589387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589387, url, valid)

proc call*(call_589388: Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_589371;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints
  ## Lists `Constraints` that could be applied on the specified resource.
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
  ##           : Name of the resource to list `Constraints` for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589389 = newJObject()
  var query_589390 = newJObject()
  var body_589391 = newJObject()
  add(query_589390, "upload_protocol", newJString(uploadProtocol))
  add(query_589390, "fields", newJString(fields))
  add(query_589390, "quotaUser", newJString(quotaUser))
  add(query_589390, "alt", newJString(alt))
  add(query_589390, "oauth_token", newJString(oauthToken))
  add(query_589390, "callback", newJString(callback))
  add(query_589390, "access_token", newJString(accessToken))
  add(query_589390, "uploadType", newJString(uploadType))
  add(query_589390, "key", newJString(key))
  add(query_589390, "$.xgafv", newJString(Xgafv))
  add(path_589389, "resource", newJString(resource))
  if body != nil:
    body_589391 = body
  add(query_589390, "prettyPrint", newJBool(prettyPrint))
  result = call_589388.call(path_589389, query_589390, nil, nil, body_589391)

var cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints* = Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_589371(
    name: "cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:listAvailableOrgPolicyConstraints", validator: validate_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_589372,
    base: "/", url: url_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_589373,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsListOrgPolicies_589392 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsListOrgPolicies_589394(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":listOrgPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsListOrgPolicies_589393(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the `Policies` set for a particular resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource to list Policies for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589395 = path.getOrDefault("resource")
  valid_589395 = validateParameter(valid_589395, JString, required = true,
                                 default = nil)
  if valid_589395 != nil:
    section.add "resource", valid_589395
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
  var valid_589396 = query.getOrDefault("upload_protocol")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "upload_protocol", valid_589396
  var valid_589397 = query.getOrDefault("fields")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "fields", valid_589397
  var valid_589398 = query.getOrDefault("quotaUser")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "quotaUser", valid_589398
  var valid_589399 = query.getOrDefault("alt")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = newJString("json"))
  if valid_589399 != nil:
    section.add "alt", valid_589399
  var valid_589400 = query.getOrDefault("oauth_token")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "oauth_token", valid_589400
  var valid_589401 = query.getOrDefault("callback")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "callback", valid_589401
  var valid_589402 = query.getOrDefault("access_token")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "access_token", valid_589402
  var valid_589403 = query.getOrDefault("uploadType")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "uploadType", valid_589403
  var valid_589404 = query.getOrDefault("key")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "key", valid_589404
  var valid_589405 = query.getOrDefault("$.xgafv")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = newJString("1"))
  if valid_589405 != nil:
    section.add "$.xgafv", valid_589405
  var valid_589406 = query.getOrDefault("prettyPrint")
  valid_589406 = validateParameter(valid_589406, JBool, required = false,
                                 default = newJBool(true))
  if valid_589406 != nil:
    section.add "prettyPrint", valid_589406
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

proc call*(call_589408: Call_CloudresourcemanagerOrganizationsListOrgPolicies_589392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the `Policies` set for a particular resource.
  ## 
  let valid = call_589408.validator(path, query, header, formData, body)
  let scheme = call_589408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589408.url(scheme.get, call_589408.host, call_589408.base,
                         call_589408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589408, url, valid)

proc call*(call_589409: Call_CloudresourcemanagerOrganizationsListOrgPolicies_589392;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsListOrgPolicies
  ## Lists all the `Policies` set for a particular resource.
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
  ##           : Name of the resource to list Policies for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589410 = newJObject()
  var query_589411 = newJObject()
  var body_589412 = newJObject()
  add(query_589411, "upload_protocol", newJString(uploadProtocol))
  add(query_589411, "fields", newJString(fields))
  add(query_589411, "quotaUser", newJString(quotaUser))
  add(query_589411, "alt", newJString(alt))
  add(query_589411, "oauth_token", newJString(oauthToken))
  add(query_589411, "callback", newJString(callback))
  add(query_589411, "access_token", newJString(accessToken))
  add(query_589411, "uploadType", newJString(uploadType))
  add(query_589411, "key", newJString(key))
  add(query_589411, "$.xgafv", newJString(Xgafv))
  add(path_589410, "resource", newJString(resource))
  if body != nil:
    body_589412 = body
  add(query_589411, "prettyPrint", newJBool(prettyPrint))
  result = call_589409.call(path_589410, query_589411, nil, nil, body_589412)

var cloudresourcemanagerOrganizationsListOrgPolicies* = Call_CloudresourcemanagerOrganizationsListOrgPolicies_589392(
    name: "cloudresourcemanagerOrganizationsListOrgPolicies",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:listOrgPolicies",
    validator: validate_CloudresourcemanagerOrganizationsListOrgPolicies_589393,
    base: "/", url: url_CloudresourcemanagerOrganizationsListOrgPolicies_589394,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSetIamPolicy_589413 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsSetIamPolicy_589415(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsSetIamPolicy_589414(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.setIamPolicy` on the specified organization
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589416 = path.getOrDefault("resource")
  valid_589416 = validateParameter(valid_589416, JString, required = true,
                                 default = nil)
  if valid_589416 != nil:
    section.add "resource", valid_589416
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
  var valid_589417 = query.getOrDefault("upload_protocol")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "upload_protocol", valid_589417
  var valid_589418 = query.getOrDefault("fields")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "fields", valid_589418
  var valid_589419 = query.getOrDefault("quotaUser")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "quotaUser", valid_589419
  var valid_589420 = query.getOrDefault("alt")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = newJString("json"))
  if valid_589420 != nil:
    section.add "alt", valid_589420
  var valid_589421 = query.getOrDefault("oauth_token")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "oauth_token", valid_589421
  var valid_589422 = query.getOrDefault("callback")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "callback", valid_589422
  var valid_589423 = query.getOrDefault("access_token")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "access_token", valid_589423
  var valid_589424 = query.getOrDefault("uploadType")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "uploadType", valid_589424
  var valid_589425 = query.getOrDefault("key")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "key", valid_589425
  var valid_589426 = query.getOrDefault("$.xgafv")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = newJString("1"))
  if valid_589426 != nil:
    section.add "$.xgafv", valid_589426
  var valid_589427 = query.getOrDefault("prettyPrint")
  valid_589427 = validateParameter(valid_589427, JBool, required = false,
                                 default = newJBool(true))
  if valid_589427 != nil:
    section.add "prettyPrint", valid_589427
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

proc call*(call_589429: Call_CloudresourcemanagerOrganizationsSetIamPolicy_589413;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.setIamPolicy` on the specified organization
  ## 
  let valid = call_589429.validator(path, query, header, formData, body)
  let scheme = call_589429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589429.url(scheme.get, call_589429.host, call_589429.base,
                         call_589429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589429, url, valid)

proc call*(call_589430: Call_CloudresourcemanagerOrganizationsSetIamPolicy_589413;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsSetIamPolicy
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.setIamPolicy` on the specified organization
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
  var path_589431 = newJObject()
  var query_589432 = newJObject()
  var body_589433 = newJObject()
  add(query_589432, "upload_protocol", newJString(uploadProtocol))
  add(query_589432, "fields", newJString(fields))
  add(query_589432, "quotaUser", newJString(quotaUser))
  add(query_589432, "alt", newJString(alt))
  add(query_589432, "oauth_token", newJString(oauthToken))
  add(query_589432, "callback", newJString(callback))
  add(query_589432, "access_token", newJString(accessToken))
  add(query_589432, "uploadType", newJString(uploadType))
  add(query_589432, "key", newJString(key))
  add(query_589432, "$.xgafv", newJString(Xgafv))
  add(path_589431, "resource", newJString(resource))
  if body != nil:
    body_589433 = body
  add(query_589432, "prettyPrint", newJBool(prettyPrint))
  result = call_589430.call(path_589431, query_589432, nil, nil, body_589433)

var cloudresourcemanagerOrganizationsSetIamPolicy* = Call_CloudresourcemanagerOrganizationsSetIamPolicy_589413(
    name: "cloudresourcemanagerOrganizationsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsSetIamPolicy_589414,
    base: "/", url: url_CloudresourcemanagerOrganizationsSetIamPolicy_589415,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSetOrgPolicy_589434 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsSetOrgPolicy_589436(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsSetOrgPolicy_589435(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the specified `Policy` on the resource. Creates a new `Policy` for
  ## that `Constraint` on the resource if one does not exist.
  ## 
  ## Not supplying an `etag` on the request `Policy` results in an unconditional
  ## write of the `Policy`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Resource name of the resource to attach the `Policy`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589437 = path.getOrDefault("resource")
  valid_589437 = validateParameter(valid_589437, JString, required = true,
                                 default = nil)
  if valid_589437 != nil:
    section.add "resource", valid_589437
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
  var valid_589438 = query.getOrDefault("upload_protocol")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "upload_protocol", valid_589438
  var valid_589439 = query.getOrDefault("fields")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "fields", valid_589439
  var valid_589440 = query.getOrDefault("quotaUser")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "quotaUser", valid_589440
  var valid_589441 = query.getOrDefault("alt")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = newJString("json"))
  if valid_589441 != nil:
    section.add "alt", valid_589441
  var valid_589442 = query.getOrDefault("oauth_token")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "oauth_token", valid_589442
  var valid_589443 = query.getOrDefault("callback")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "callback", valid_589443
  var valid_589444 = query.getOrDefault("access_token")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "access_token", valid_589444
  var valid_589445 = query.getOrDefault("uploadType")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "uploadType", valid_589445
  var valid_589446 = query.getOrDefault("key")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "key", valid_589446
  var valid_589447 = query.getOrDefault("$.xgafv")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = newJString("1"))
  if valid_589447 != nil:
    section.add "$.xgafv", valid_589447
  var valid_589448 = query.getOrDefault("prettyPrint")
  valid_589448 = validateParameter(valid_589448, JBool, required = false,
                                 default = newJBool(true))
  if valid_589448 != nil:
    section.add "prettyPrint", valid_589448
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

proc call*(call_589450: Call_CloudresourcemanagerOrganizationsSetOrgPolicy_589434;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified `Policy` on the resource. Creates a new `Policy` for
  ## that `Constraint` on the resource if one does not exist.
  ## 
  ## Not supplying an `etag` on the request `Policy` results in an unconditional
  ## write of the `Policy`.
  ## 
  let valid = call_589450.validator(path, query, header, formData, body)
  let scheme = call_589450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589450.url(scheme.get, call_589450.host, call_589450.base,
                         call_589450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589450, url, valid)

proc call*(call_589451: Call_CloudresourcemanagerOrganizationsSetOrgPolicy_589434;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsSetOrgPolicy
  ## Updates the specified `Policy` on the resource. Creates a new `Policy` for
  ## that `Constraint` on the resource if one does not exist.
  ## 
  ## Not supplying an `etag` on the request `Policy` results in an unconditional
  ## write of the `Policy`.
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
  ##           : Resource name of the resource to attach the `Policy`.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589452 = newJObject()
  var query_589453 = newJObject()
  var body_589454 = newJObject()
  add(query_589453, "upload_protocol", newJString(uploadProtocol))
  add(query_589453, "fields", newJString(fields))
  add(query_589453, "quotaUser", newJString(quotaUser))
  add(query_589453, "alt", newJString(alt))
  add(query_589453, "oauth_token", newJString(oauthToken))
  add(query_589453, "callback", newJString(callback))
  add(query_589453, "access_token", newJString(accessToken))
  add(query_589453, "uploadType", newJString(uploadType))
  add(query_589453, "key", newJString(key))
  add(query_589453, "$.xgafv", newJString(Xgafv))
  add(path_589452, "resource", newJString(resource))
  if body != nil:
    body_589454 = body
  add(query_589453, "prettyPrint", newJBool(prettyPrint))
  result = call_589451.call(path_589452, query_589453, nil, nil, body_589454)

var cloudresourcemanagerOrganizationsSetOrgPolicy* = Call_CloudresourcemanagerOrganizationsSetOrgPolicy_589434(
    name: "cloudresourcemanagerOrganizationsSetOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:setOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsSetOrgPolicy_589435,
    base: "/", url: url_CloudresourcemanagerOrganizationsSetOrgPolicy_589436,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsTestIamPermissions_589455 = ref object of OpenApiRestCall_588450
proc url_CloudresourcemanagerOrganizationsTestIamPermissions_589457(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsTestIamPermissions_589456(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
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
  var valid_589458 = path.getOrDefault("resource")
  valid_589458 = validateParameter(valid_589458, JString, required = true,
                                 default = nil)
  if valid_589458 != nil:
    section.add "resource", valid_589458
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
  var valid_589459 = query.getOrDefault("upload_protocol")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "upload_protocol", valid_589459
  var valid_589460 = query.getOrDefault("fields")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "fields", valid_589460
  var valid_589461 = query.getOrDefault("quotaUser")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "quotaUser", valid_589461
  var valid_589462 = query.getOrDefault("alt")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = newJString("json"))
  if valid_589462 != nil:
    section.add "alt", valid_589462
  var valid_589463 = query.getOrDefault("oauth_token")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "oauth_token", valid_589463
  var valid_589464 = query.getOrDefault("callback")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "callback", valid_589464
  var valid_589465 = query.getOrDefault("access_token")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "access_token", valid_589465
  var valid_589466 = query.getOrDefault("uploadType")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "uploadType", valid_589466
  var valid_589467 = query.getOrDefault("key")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "key", valid_589467
  var valid_589468 = query.getOrDefault("$.xgafv")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = newJString("1"))
  if valid_589468 != nil:
    section.add "$.xgafv", valid_589468
  var valid_589469 = query.getOrDefault("prettyPrint")
  valid_589469 = validateParameter(valid_589469, JBool, required = false,
                                 default = newJBool(true))
  if valid_589469 != nil:
    section.add "prettyPrint", valid_589469
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

proc call*(call_589471: Call_CloudresourcemanagerOrganizationsTestIamPermissions_589455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_589471.validator(path, query, header, formData, body)
  let scheme = call_589471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589471.url(scheme.get, call_589471.host, call_589471.base,
                         call_589471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589471, url, valid)

proc call*(call_589472: Call_CloudresourcemanagerOrganizationsTestIamPermissions_589455;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsTestIamPermissions
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
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
  var path_589473 = newJObject()
  var query_589474 = newJObject()
  var body_589475 = newJObject()
  add(query_589474, "upload_protocol", newJString(uploadProtocol))
  add(query_589474, "fields", newJString(fields))
  add(query_589474, "quotaUser", newJString(quotaUser))
  add(query_589474, "alt", newJString(alt))
  add(query_589474, "oauth_token", newJString(oauthToken))
  add(query_589474, "callback", newJString(callback))
  add(query_589474, "access_token", newJString(accessToken))
  add(query_589474, "uploadType", newJString(uploadType))
  add(query_589474, "key", newJString(key))
  add(query_589474, "$.xgafv", newJString(Xgafv))
  add(path_589473, "resource", newJString(resource))
  if body != nil:
    body_589475 = body
  add(query_589474, "prettyPrint", newJBool(prettyPrint))
  result = call_589472.call(path_589473, query_589474, nil, nil, body_589475)

var cloudresourcemanagerOrganizationsTestIamPermissions* = Call_CloudresourcemanagerOrganizationsTestIamPermissions_589455(
    name: "cloudresourcemanagerOrganizationsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerOrganizationsTestIamPermissions_589456,
    base: "/", url: url_CloudresourcemanagerOrganizationsTestIamPermissions_589457,
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
