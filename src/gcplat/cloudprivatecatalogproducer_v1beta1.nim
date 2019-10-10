
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Private Catalog Producer
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Enables cloud users to manage and share enterprise catalogs intheir organizations.
## 
## https://cloud.google.com/private-catalog/
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
  gcpServiceName = "cloudprivatecatalogproducer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprivatecatalogproducerCatalogsCreate_588985 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsCreate_588987(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerCatalogsCreate_588986(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Catalog resource.
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
  var valid_588988 = query.getOrDefault("upload_protocol")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "upload_protocol", valid_588988
  var valid_588989 = query.getOrDefault("fields")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "fields", valid_588989
  var valid_588990 = query.getOrDefault("quotaUser")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "quotaUser", valid_588990
  var valid_588991 = query.getOrDefault("alt")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = newJString("json"))
  if valid_588991 != nil:
    section.add "alt", valid_588991
  var valid_588992 = query.getOrDefault("oauth_token")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "oauth_token", valid_588992
  var valid_588993 = query.getOrDefault("callback")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "callback", valid_588993
  var valid_588994 = query.getOrDefault("access_token")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "access_token", valid_588994
  var valid_588995 = query.getOrDefault("uploadType")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "uploadType", valid_588995
  var valid_588996 = query.getOrDefault("key")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "key", valid_588996
  var valid_588997 = query.getOrDefault("$.xgafv")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = newJString("1"))
  if valid_588997 != nil:
    section.add "$.xgafv", valid_588997
  var valid_588998 = query.getOrDefault("prettyPrint")
  valid_588998 = validateParameter(valid_588998, JBool, required = false,
                                 default = newJBool(true))
  if valid_588998 != nil:
    section.add "prettyPrint", valid_588998
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

proc call*(call_589000: Call_CloudprivatecatalogproducerCatalogsCreate_588985;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Catalog resource.
  ## 
  let valid = call_589000.validator(path, query, header, formData, body)
  let scheme = call_589000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589000.url(scheme.get, call_589000.host, call_589000.base,
                         call_589000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589000, url, valid)

proc call*(call_589001: Call_CloudprivatecatalogproducerCatalogsCreate_588985;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsCreate
  ## Creates a new Catalog resource.
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
  var query_589002 = newJObject()
  var body_589003 = newJObject()
  add(query_589002, "upload_protocol", newJString(uploadProtocol))
  add(query_589002, "fields", newJString(fields))
  add(query_589002, "quotaUser", newJString(quotaUser))
  add(query_589002, "alt", newJString(alt))
  add(query_589002, "oauth_token", newJString(oauthToken))
  add(query_589002, "callback", newJString(callback))
  add(query_589002, "access_token", newJString(accessToken))
  add(query_589002, "uploadType", newJString(uploadType))
  add(query_589002, "key", newJString(key))
  add(query_589002, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589003 = body
  add(query_589002, "prettyPrint", newJBool(prettyPrint))
  result = call_589001.call(nil, query_589002, nil, nil, body_589003)

var cloudprivatecatalogproducerCatalogsCreate* = Call_CloudprivatecatalogproducerCatalogsCreate_588985(
    name: "cloudprivatecatalogproducerCatalogsCreate", meth: HttpMethod.HttpPost,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/catalogs",
    validator: validate_CloudprivatecatalogproducerCatalogsCreate_588986,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsCreate_588987,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsList_588710 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsList_588712(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerCatalogsList_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
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
  ##            : A pagination token returned from a previous call to ListCatalogs
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
  ##         : The resource name of the parent resource.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of catalogs to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("pageToken")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "pageToken", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("oauth_token")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "oauth_token", valid_588842
  var valid_588843 = query.getOrDefault("callback")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "callback", valid_588843
  var valid_588844 = query.getOrDefault("access_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "access_token", valid_588844
  var valid_588845 = query.getOrDefault("uploadType")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "uploadType", valid_588845
  var valid_588846 = query.getOrDefault("parent")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "parent", valid_588846
  var valid_588847 = query.getOrDefault("key")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "key", valid_588847
  var valid_588848 = query.getOrDefault("$.xgafv")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = newJString("1"))
  if valid_588848 != nil:
    section.add "$.xgafv", valid_588848
  var valid_588849 = query.getOrDefault("pageSize")
  valid_588849 = validateParameter(valid_588849, JInt, required = false, default = nil)
  if valid_588849 != nil:
    section.add "pageSize", valid_588849
  var valid_588850 = query.getOrDefault("prettyPrint")
  valid_588850 = validateParameter(valid_588850, JBool, required = false,
                                 default = newJBool(true))
  if valid_588850 != nil:
    section.add "prettyPrint", valid_588850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588873: Call_CloudprivatecatalogproducerCatalogsList_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
  ## 
  let valid = call_588873.validator(path, query, header, formData, body)
  let scheme = call_588873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588873.url(scheme.get, call_588873.host, call_588873.base,
                         call_588873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588873, url, valid)

proc call*(call_588944: Call_CloudprivatecatalogproducerCatalogsList_588710;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          parent: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsList
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListCatalogs
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
  ##         : The resource name of the parent resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of catalogs to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588945 = newJObject()
  add(query_588945, "upload_protocol", newJString(uploadProtocol))
  add(query_588945, "fields", newJString(fields))
  add(query_588945, "pageToken", newJString(pageToken))
  add(query_588945, "quotaUser", newJString(quotaUser))
  add(query_588945, "alt", newJString(alt))
  add(query_588945, "oauth_token", newJString(oauthToken))
  add(query_588945, "callback", newJString(callback))
  add(query_588945, "access_token", newJString(accessToken))
  add(query_588945, "uploadType", newJString(uploadType))
  add(query_588945, "parent", newJString(parent))
  add(query_588945, "key", newJString(key))
  add(query_588945, "$.xgafv", newJString(Xgafv))
  add(query_588945, "pageSize", newJInt(pageSize))
  add(query_588945, "prettyPrint", newJBool(prettyPrint))
  result = call_588944.call(nil, query_588945, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsList* = Call_CloudprivatecatalogproducerCatalogsList_588710(
    name: "cloudprivatecatalogproducerCatalogsList", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/catalogs",
    validator: validate_CloudprivatecatalogproducerCatalogsList_588711, base: "/",
    url: url_CloudprivatecatalogproducerCatalogsList_588712,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsList_589004 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerOperationsList_589006(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerOperationsList_589005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
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
  ##            : The standard list page token.
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
  ##   name: JString
  ##       : The name of the operation's parent resource.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_589007 = query.getOrDefault("upload_protocol")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "upload_protocol", valid_589007
  var valid_589008 = query.getOrDefault("fields")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "fields", valid_589008
  var valid_589009 = query.getOrDefault("pageToken")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "pageToken", valid_589009
  var valid_589010 = query.getOrDefault("quotaUser")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "quotaUser", valid_589010
  var valid_589011 = query.getOrDefault("alt")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("json"))
  if valid_589011 != nil:
    section.add "alt", valid_589011
  var valid_589012 = query.getOrDefault("oauth_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "oauth_token", valid_589012
  var valid_589013 = query.getOrDefault("callback")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "callback", valid_589013
  var valid_589014 = query.getOrDefault("access_token")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "access_token", valid_589014
  var valid_589015 = query.getOrDefault("uploadType")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "uploadType", valid_589015
  var valid_589016 = query.getOrDefault("key")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "key", valid_589016
  var valid_589017 = query.getOrDefault("name")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "name", valid_589017
  var valid_589018 = query.getOrDefault("$.xgafv")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("1"))
  if valid_589018 != nil:
    section.add "$.xgafv", valid_589018
  var valid_589019 = query.getOrDefault("pageSize")
  valid_589019 = validateParameter(valid_589019, JInt, required = false, default = nil)
  if valid_589019 != nil:
    section.add "pageSize", valid_589019
  var valid_589020 = query.getOrDefault("prettyPrint")
  valid_589020 = validateParameter(valid_589020, JBool, required = false,
                                 default = newJBool(true))
  if valid_589020 != nil:
    section.add "prettyPrint", valid_589020
  var valid_589021 = query.getOrDefault("filter")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "filter", valid_589021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589022: Call_CloudprivatecatalogproducerOperationsList_589004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_589022.validator(path, query, header, formData, body)
  let scheme = call_589022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589022.url(scheme.get, call_589022.host, call_589022.base,
                         call_589022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589022, url, valid)

proc call*(call_589023: Call_CloudprivatecatalogproducerOperationsList_589004;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudprivatecatalogproducerOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
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
  ##   name: string
  ##       : The name of the operation's parent resource.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var query_589024 = newJObject()
  add(query_589024, "upload_protocol", newJString(uploadProtocol))
  add(query_589024, "fields", newJString(fields))
  add(query_589024, "pageToken", newJString(pageToken))
  add(query_589024, "quotaUser", newJString(quotaUser))
  add(query_589024, "alt", newJString(alt))
  add(query_589024, "oauth_token", newJString(oauthToken))
  add(query_589024, "callback", newJString(callback))
  add(query_589024, "access_token", newJString(accessToken))
  add(query_589024, "uploadType", newJString(uploadType))
  add(query_589024, "key", newJString(key))
  add(query_589024, "name", newJString(name))
  add(query_589024, "$.xgafv", newJString(Xgafv))
  add(query_589024, "pageSize", newJInt(pageSize))
  add(query_589024, "prettyPrint", newJBool(prettyPrint))
  add(query_589024, "filter", newJString(filter))
  result = call_589023.call(nil, query_589024, nil, nil, nil)

var cloudprivatecatalogproducerOperationsList* = Call_CloudprivatecatalogproducerOperationsList_589004(
    name: "cloudprivatecatalogproducerOperationsList", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/operations",
    validator: validate_CloudprivatecatalogproducerOperationsList_589005,
    base: "/", url: url_CloudprivatecatalogproducerOperationsList_589006,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsGet_589025 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsGet_589027(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsGet_589026(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the requested Version resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the version.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589042 = path.getOrDefault("name")
  valid_589042 = validateParameter(valid_589042, JString, required = true,
                                 default = nil)
  if valid_589042 != nil:
    section.add "name", valid_589042
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
  var valid_589043 = query.getOrDefault("upload_protocol")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "upload_protocol", valid_589043
  var valid_589044 = query.getOrDefault("fields")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "fields", valid_589044
  var valid_589045 = query.getOrDefault("quotaUser")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "quotaUser", valid_589045
  var valid_589046 = query.getOrDefault("alt")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = newJString("json"))
  if valid_589046 != nil:
    section.add "alt", valid_589046
  var valid_589047 = query.getOrDefault("oauth_token")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "oauth_token", valid_589047
  var valid_589048 = query.getOrDefault("callback")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "callback", valid_589048
  var valid_589049 = query.getOrDefault("access_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "access_token", valid_589049
  var valid_589050 = query.getOrDefault("uploadType")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "uploadType", valid_589050
  var valid_589051 = query.getOrDefault("key")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "key", valid_589051
  var valid_589052 = query.getOrDefault("$.xgafv")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("1"))
  if valid_589052 != nil:
    section.add "$.xgafv", valid_589052
  var valid_589053 = query.getOrDefault("prettyPrint")
  valid_589053 = validateParameter(valid_589053, JBool, required = false,
                                 default = newJBool(true))
  if valid_589053 != nil:
    section.add "prettyPrint", valid_589053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589054: Call_CloudprivatecatalogproducerCatalogsProductsVersionsGet_589025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the requested Version resource.
  ## 
  let valid = call_589054.validator(path, query, header, formData, body)
  let scheme = call_589054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589054.url(scheme.get, call_589054.host, call_589054.base,
                         call_589054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589054, url, valid)

proc call*(call_589055: Call_CloudprivatecatalogproducerCatalogsProductsVersionsGet_589025;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsGet
  ## Returns the requested Version resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the version.
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
  var path_589056 = newJObject()
  var query_589057 = newJObject()
  add(query_589057, "upload_protocol", newJString(uploadProtocol))
  add(query_589057, "fields", newJString(fields))
  add(query_589057, "quotaUser", newJString(quotaUser))
  add(path_589056, "name", newJString(name))
  add(query_589057, "alt", newJString(alt))
  add(query_589057, "oauth_token", newJString(oauthToken))
  add(query_589057, "callback", newJString(callback))
  add(query_589057, "access_token", newJString(accessToken))
  add(query_589057, "uploadType", newJString(uploadType))
  add(query_589057, "key", newJString(key))
  add(query_589057, "$.xgafv", newJString(Xgafv))
  add(query_589057, "prettyPrint", newJBool(prettyPrint))
  result = call_589055.call(path_589056, query_589057, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsVersionsGet* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsGet_589025(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsGet",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsGet_589026,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsGet_589027,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_589078 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_589080(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_589079(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates a specific Version resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the version, in the format
  ## `catalogs/{catalog_id}/products/{product_id}/versions/a-z*[a-z0-9]'.
  ## 
  ## A unique identifier for the version under a product, which can't
  ## be changed after the version is created. The final segment of the name must
  ## between 1 and 63 characters in length.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589081 = path.getOrDefault("name")
  valid_589081 = validateParameter(valid_589081, JString, required = true,
                                 default = nil)
  if valid_589081 != nil:
    section.add "name", valid_589081
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
  ##             : Field mask that controls which fields of the version should be updated.
  section = newJObject()
  var valid_589082 = query.getOrDefault("upload_protocol")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "upload_protocol", valid_589082
  var valid_589083 = query.getOrDefault("fields")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "fields", valid_589083
  var valid_589084 = query.getOrDefault("quotaUser")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "quotaUser", valid_589084
  var valid_589085 = query.getOrDefault("alt")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("json"))
  if valid_589085 != nil:
    section.add "alt", valid_589085
  var valid_589086 = query.getOrDefault("oauth_token")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "oauth_token", valid_589086
  var valid_589087 = query.getOrDefault("callback")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "callback", valid_589087
  var valid_589088 = query.getOrDefault("access_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "access_token", valid_589088
  var valid_589089 = query.getOrDefault("uploadType")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "uploadType", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("$.xgafv")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = newJString("1"))
  if valid_589091 != nil:
    section.add "$.xgafv", valid_589091
  var valid_589092 = query.getOrDefault("prettyPrint")
  valid_589092 = validateParameter(valid_589092, JBool, required = false,
                                 default = newJBool(true))
  if valid_589092 != nil:
    section.add "prettyPrint", valid_589092
  var valid_589093 = query.getOrDefault("updateMask")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "updateMask", valid_589093
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

proc call*(call_589095: Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_589078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a specific Version resource.
  ## 
  let valid = call_589095.validator(path, query, header, formData, body)
  let scheme = call_589095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589095.url(scheme.get, call_589095.host, call_589095.base,
                         call_589095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589095, url, valid)

proc call*(call_589096: Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_589078;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsPatch
  ## Updates a specific Version resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the version, in the format
  ## `catalogs/{catalog_id}/products/{product_id}/versions/a-z*[a-z0-9]'.
  ## 
  ## A unique identifier for the version under a product, which can't
  ## be changed after the version is created. The final segment of the name must
  ## between 1 and 63 characters in length.
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
  ##             : Field mask that controls which fields of the version should be updated.
  var path_589097 = newJObject()
  var query_589098 = newJObject()
  var body_589099 = newJObject()
  add(query_589098, "upload_protocol", newJString(uploadProtocol))
  add(query_589098, "fields", newJString(fields))
  add(query_589098, "quotaUser", newJString(quotaUser))
  add(path_589097, "name", newJString(name))
  add(query_589098, "alt", newJString(alt))
  add(query_589098, "oauth_token", newJString(oauthToken))
  add(query_589098, "callback", newJString(callback))
  add(query_589098, "access_token", newJString(accessToken))
  add(query_589098, "uploadType", newJString(uploadType))
  add(query_589098, "key", newJString(key))
  add(query_589098, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589099 = body
  add(query_589098, "prettyPrint", newJBool(prettyPrint))
  add(query_589098, "updateMask", newJString(updateMask))
  result = call_589096.call(path_589097, query_589098, nil, nil, body_589099)

var cloudprivatecatalogproducerCatalogsProductsVersionsPatch* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_589078(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsPatch",
    meth: HttpMethod.HttpPatch,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_589079,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_589080,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_589058 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_589060(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_589059(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Hard deletes a Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the version.
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
  ##   force: JBool
  ##        : Forces deletion of the `Catalog` and its `Association` resources.
  ## If the `Catalog` is still associated with other resources and
  ## force is not set to true, then the operation fails.
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
  var valid_589064 = query.getOrDefault("force")
  valid_589064 = validateParameter(valid_589064, JBool, required = false, default = nil)
  if valid_589064 != nil:
    section.add "force", valid_589064
  var valid_589065 = query.getOrDefault("quotaUser")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "quotaUser", valid_589065
  var valid_589066 = query.getOrDefault("alt")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = newJString("json"))
  if valid_589066 != nil:
    section.add "alt", valid_589066
  var valid_589067 = query.getOrDefault("oauth_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "oauth_token", valid_589067
  var valid_589068 = query.getOrDefault("callback")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "callback", valid_589068
  var valid_589069 = query.getOrDefault("access_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "access_token", valid_589069
  var valid_589070 = query.getOrDefault("uploadType")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "uploadType", valid_589070
  var valid_589071 = query.getOrDefault("key")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "key", valid_589071
  var valid_589072 = query.getOrDefault("$.xgafv")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("1"))
  if valid_589072 != nil:
    section.add "$.xgafv", valid_589072
  var valid_589073 = query.getOrDefault("prettyPrint")
  valid_589073 = validateParameter(valid_589073, JBool, required = false,
                                 default = newJBool(true))
  if valid_589073 != nil:
    section.add "prettyPrint", valid_589073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589074: Call_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_589058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Hard deletes a Version.
  ## 
  let valid = call_589074.validator(path, query, header, formData, body)
  let scheme = call_589074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589074.url(scheme.get, call_589074.host, call_589074.base,
                         call_589074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589074, url, valid)

proc call*(call_589075: Call_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_589058;
          name: string; uploadProtocol: string = ""; fields: string = "";
          force: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsDelete
  ## Hard deletes a Version.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: bool
  ##        : Forces deletion of the `Catalog` and its `Association` resources.
  ## If the `Catalog` is still associated with other resources and
  ## force is not set to true, then the operation fails.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the version.
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
  var path_589076 = newJObject()
  var query_589077 = newJObject()
  add(query_589077, "upload_protocol", newJString(uploadProtocol))
  add(query_589077, "fields", newJString(fields))
  add(query_589077, "force", newJBool(force))
  add(query_589077, "quotaUser", newJString(quotaUser))
  add(path_589076, "name", newJString(name))
  add(query_589077, "alt", newJString(alt))
  add(query_589077, "oauth_token", newJString(oauthToken))
  add(query_589077, "callback", newJString(callback))
  add(query_589077, "access_token", newJString(accessToken))
  add(query_589077, "uploadType", newJString(uploadType))
  add(query_589077, "key", newJString(key))
  add(query_589077, "$.xgafv", newJString(Xgafv))
  add(query_589077, "prettyPrint", newJBool(prettyPrint))
  result = call_589075.call(path_589076, query_589077, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsVersionsDelete* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_589058(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsDelete",
    meth: HttpMethod.HttpDelete,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_589059,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_589060,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsCancel_589100 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerOperationsCancel_589102(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerOperationsCancel_589101(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589103 = path.getOrDefault("name")
  valid_589103 = validateParameter(valid_589103, JString, required = true,
                                 default = nil)
  if valid_589103 != nil:
    section.add "name", valid_589103
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
  var valid_589104 = query.getOrDefault("upload_protocol")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "upload_protocol", valid_589104
  var valid_589105 = query.getOrDefault("fields")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "fields", valid_589105
  var valid_589106 = query.getOrDefault("quotaUser")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "quotaUser", valid_589106
  var valid_589107 = query.getOrDefault("alt")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = newJString("json"))
  if valid_589107 != nil:
    section.add "alt", valid_589107
  var valid_589108 = query.getOrDefault("oauth_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "oauth_token", valid_589108
  var valid_589109 = query.getOrDefault("callback")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "callback", valid_589109
  var valid_589110 = query.getOrDefault("access_token")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "access_token", valid_589110
  var valid_589111 = query.getOrDefault("uploadType")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "uploadType", valid_589111
  var valid_589112 = query.getOrDefault("key")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "key", valid_589112
  var valid_589113 = query.getOrDefault("$.xgafv")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("1"))
  if valid_589113 != nil:
    section.add "$.xgafv", valid_589113
  var valid_589114 = query.getOrDefault("prettyPrint")
  valid_589114 = validateParameter(valid_589114, JBool, required = false,
                                 default = newJBool(true))
  if valid_589114 != nil:
    section.add "prettyPrint", valid_589114
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

proc call*(call_589116: Call_CloudprivatecatalogproducerOperationsCancel_589100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_589116.validator(path, query, header, formData, body)
  let scheme = call_589116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589116.url(scheme.get, call_589116.host, call_589116.base,
                         call_589116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589116, url, valid)

proc call*(call_589117: Call_CloudprivatecatalogproducerOperationsCancel_589100;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_589118 = newJObject()
  var query_589119 = newJObject()
  var body_589120 = newJObject()
  add(query_589119, "upload_protocol", newJString(uploadProtocol))
  add(query_589119, "fields", newJString(fields))
  add(query_589119, "quotaUser", newJString(quotaUser))
  add(path_589118, "name", newJString(name))
  add(query_589119, "alt", newJString(alt))
  add(query_589119, "oauth_token", newJString(oauthToken))
  add(query_589119, "callback", newJString(callback))
  add(query_589119, "access_token", newJString(accessToken))
  add(query_589119, "uploadType", newJString(uploadType))
  add(query_589119, "key", newJString(key))
  add(query_589119, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589120 = body
  add(query_589119, "prettyPrint", newJBool(prettyPrint))
  result = call_589117.call(path_589118, query_589119, nil, nil, body_589120)

var cloudprivatecatalogproducerOperationsCancel* = Call_CloudprivatecatalogproducerOperationsCancel_589100(
    name: "cloudprivatecatalogproducerOperationsCancel",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:cancel",
    validator: validate_CloudprivatecatalogproducerOperationsCancel_589101,
    base: "/", url: url_CloudprivatecatalogproducerOperationsCancel_589102,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsCopy_589121 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsProductsCopy_589123(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":copy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsCopy_589122(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Copies a Product under another Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the current product that is copied from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589124 = path.getOrDefault("name")
  valid_589124 = validateParameter(valid_589124, JString, required = true,
                                 default = nil)
  if valid_589124 != nil:
    section.add "name", valid_589124
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
  var valid_589125 = query.getOrDefault("upload_protocol")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "upload_protocol", valid_589125
  var valid_589126 = query.getOrDefault("fields")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "fields", valid_589126
  var valid_589127 = query.getOrDefault("quotaUser")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "quotaUser", valid_589127
  var valid_589128 = query.getOrDefault("alt")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = newJString("json"))
  if valid_589128 != nil:
    section.add "alt", valid_589128
  var valid_589129 = query.getOrDefault("oauth_token")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "oauth_token", valid_589129
  var valid_589130 = query.getOrDefault("callback")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "callback", valid_589130
  var valid_589131 = query.getOrDefault("access_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "access_token", valid_589131
  var valid_589132 = query.getOrDefault("uploadType")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "uploadType", valid_589132
  var valid_589133 = query.getOrDefault("key")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "key", valid_589133
  var valid_589134 = query.getOrDefault("$.xgafv")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = newJString("1"))
  if valid_589134 != nil:
    section.add "$.xgafv", valid_589134
  var valid_589135 = query.getOrDefault("prettyPrint")
  valid_589135 = validateParameter(valid_589135, JBool, required = false,
                                 default = newJBool(true))
  if valid_589135 != nil:
    section.add "prettyPrint", valid_589135
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

proc call*(call_589137: Call_CloudprivatecatalogproducerCatalogsProductsCopy_589121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Copies a Product under another Catalog.
  ## 
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_CloudprivatecatalogproducerCatalogsProductsCopy_589121;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsCopy
  ## Copies a Product under another Catalog.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the current product that is copied from.
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
  var path_589139 = newJObject()
  var query_589140 = newJObject()
  var body_589141 = newJObject()
  add(query_589140, "upload_protocol", newJString(uploadProtocol))
  add(query_589140, "fields", newJString(fields))
  add(query_589140, "quotaUser", newJString(quotaUser))
  add(path_589139, "name", newJString(name))
  add(query_589140, "alt", newJString(alt))
  add(query_589140, "oauth_token", newJString(oauthToken))
  add(query_589140, "callback", newJString(callback))
  add(query_589140, "access_token", newJString(accessToken))
  add(query_589140, "uploadType", newJString(uploadType))
  add(query_589140, "key", newJString(key))
  add(query_589140, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589141 = body
  add(query_589140, "prettyPrint", newJBool(prettyPrint))
  result = call_589138.call(path_589139, query_589140, nil, nil, body_589141)

var cloudprivatecatalogproducerCatalogsProductsCopy* = Call_CloudprivatecatalogproducerCatalogsProductsCopy_589121(
    name: "cloudprivatecatalogproducerCatalogsProductsCopy",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:copy",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsCopy_589122,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsCopy_589123,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsUndelete_589142 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsUndelete_589144(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsUndelete_589143(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undeletes a deleted Catalog and all resources under it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the catalog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589145 = path.getOrDefault("name")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "name", valid_589145
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
  var valid_589146 = query.getOrDefault("upload_protocol")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "upload_protocol", valid_589146
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("oauth_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "oauth_token", valid_589150
  var valid_589151 = query.getOrDefault("callback")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "callback", valid_589151
  var valid_589152 = query.getOrDefault("access_token")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "access_token", valid_589152
  var valid_589153 = query.getOrDefault("uploadType")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "uploadType", valid_589153
  var valid_589154 = query.getOrDefault("key")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "key", valid_589154
  var valid_589155 = query.getOrDefault("$.xgafv")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = newJString("1"))
  if valid_589155 != nil:
    section.add "$.xgafv", valid_589155
  var valid_589156 = query.getOrDefault("prettyPrint")
  valid_589156 = validateParameter(valid_589156, JBool, required = false,
                                 default = newJBool(true))
  if valid_589156 != nil:
    section.add "prettyPrint", valid_589156
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

proc call*(call_589158: Call_CloudprivatecatalogproducerCatalogsUndelete_589142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Undeletes a deleted Catalog and all resources under it.
  ## 
  let valid = call_589158.validator(path, query, header, formData, body)
  let scheme = call_589158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589158.url(scheme.get, call_589158.host, call_589158.base,
                         call_589158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589158, url, valid)

proc call*(call_589159: Call_CloudprivatecatalogproducerCatalogsUndelete_589142;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsUndelete
  ## Undeletes a deleted Catalog and all resources under it.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the catalog.
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
  var path_589160 = newJObject()
  var query_589161 = newJObject()
  var body_589162 = newJObject()
  add(query_589161, "upload_protocol", newJString(uploadProtocol))
  add(query_589161, "fields", newJString(fields))
  add(query_589161, "quotaUser", newJString(quotaUser))
  add(path_589160, "name", newJString(name))
  add(query_589161, "alt", newJString(alt))
  add(query_589161, "oauth_token", newJString(oauthToken))
  add(query_589161, "callback", newJString(callback))
  add(query_589161, "access_token", newJString(accessToken))
  add(query_589161, "uploadType", newJString(uploadType))
  add(query_589161, "key", newJString(key))
  add(query_589161, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589162 = body
  add(query_589161, "prettyPrint", newJBool(prettyPrint))
  result = call_589159.call(path_589160, query_589161, nil, nil, body_589162)

var cloudprivatecatalogproducerCatalogsUndelete* = Call_CloudprivatecatalogproducerCatalogsUndelete_589142(
    name: "cloudprivatecatalogproducerCatalogsUndelete",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:undelete",
    validator: validate_CloudprivatecatalogproducerCatalogsUndelete_589143,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsUndelete_589144,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_589184 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsAssociationsCreate_589186(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/associations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsAssociationsCreate_589185(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an Association instance under a given Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The `Catalog` resource's name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589187 = path.getOrDefault("parent")
  valid_589187 = validateParameter(valid_589187, JString, required = true,
                                 default = nil)
  if valid_589187 != nil:
    section.add "parent", valid_589187
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
  var valid_589188 = query.getOrDefault("upload_protocol")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "upload_protocol", valid_589188
  var valid_589189 = query.getOrDefault("fields")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "fields", valid_589189
  var valid_589190 = query.getOrDefault("quotaUser")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "quotaUser", valid_589190
  var valid_589191 = query.getOrDefault("alt")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = newJString("json"))
  if valid_589191 != nil:
    section.add "alt", valid_589191
  var valid_589192 = query.getOrDefault("oauth_token")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "oauth_token", valid_589192
  var valid_589193 = query.getOrDefault("callback")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "callback", valid_589193
  var valid_589194 = query.getOrDefault("access_token")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "access_token", valid_589194
  var valid_589195 = query.getOrDefault("uploadType")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "uploadType", valid_589195
  var valid_589196 = query.getOrDefault("key")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "key", valid_589196
  var valid_589197 = query.getOrDefault("$.xgafv")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = newJString("1"))
  if valid_589197 != nil:
    section.add "$.xgafv", valid_589197
  var valid_589198 = query.getOrDefault("prettyPrint")
  valid_589198 = validateParameter(valid_589198, JBool, required = false,
                                 default = newJBool(true))
  if valid_589198 != nil:
    section.add "prettyPrint", valid_589198
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

proc call*(call_589200: Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_589184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Association instance under a given Catalog.
  ## 
  let valid = call_589200.validator(path, query, header, formData, body)
  let scheme = call_589200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589200.url(scheme.get, call_589200.host, call_589200.base,
                         call_589200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589200, url, valid)

proc call*(call_589201: Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_589184;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsAssociationsCreate
  ## Creates an Association instance under a given Catalog.
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
  ##         : The `Catalog` resource's name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589202 = newJObject()
  var query_589203 = newJObject()
  var body_589204 = newJObject()
  add(query_589203, "upload_protocol", newJString(uploadProtocol))
  add(query_589203, "fields", newJString(fields))
  add(query_589203, "quotaUser", newJString(quotaUser))
  add(query_589203, "alt", newJString(alt))
  add(query_589203, "oauth_token", newJString(oauthToken))
  add(query_589203, "callback", newJString(callback))
  add(query_589203, "access_token", newJString(accessToken))
  add(query_589203, "uploadType", newJString(uploadType))
  add(path_589202, "parent", newJString(parent))
  add(query_589203, "key", newJString(key))
  add(query_589203, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589204 = body
  add(query_589203, "prettyPrint", newJBool(prettyPrint))
  result = call_589201.call(path_589202, query_589203, nil, nil, body_589204)

var cloudprivatecatalogproducerCatalogsAssociationsCreate* = Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_589184(
    name: "cloudprivatecatalogproducerCatalogsAssociationsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/associations",
    validator: validate_CloudprivatecatalogproducerCatalogsAssociationsCreate_589185,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsAssociationsCreate_589186,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsAssociationsList_589163 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsAssociationsList_589165(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/associations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsAssociationsList_589164(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all Association resources under a catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the `Catalog` whose `Associations` are
  ## being retrieved. In the format `catalogs/<catalog>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589166 = path.getOrDefault("parent")
  valid_589166 = validateParameter(valid_589166, JString, required = true,
                                 default = nil)
  if valid_589166 != nil:
    section.add "parent", valid_589166
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from the previous call to
  ## `ListAssociations`.
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
  ##           : The maximum number of catalog associations to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589167 = query.getOrDefault("upload_protocol")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "upload_protocol", valid_589167
  var valid_589168 = query.getOrDefault("fields")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "fields", valid_589168
  var valid_589169 = query.getOrDefault("pageToken")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "pageToken", valid_589169
  var valid_589170 = query.getOrDefault("quotaUser")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "quotaUser", valid_589170
  var valid_589171 = query.getOrDefault("alt")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = newJString("json"))
  if valid_589171 != nil:
    section.add "alt", valid_589171
  var valid_589172 = query.getOrDefault("oauth_token")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "oauth_token", valid_589172
  var valid_589173 = query.getOrDefault("callback")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "callback", valid_589173
  var valid_589174 = query.getOrDefault("access_token")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "access_token", valid_589174
  var valid_589175 = query.getOrDefault("uploadType")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "uploadType", valid_589175
  var valid_589176 = query.getOrDefault("key")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "key", valid_589176
  var valid_589177 = query.getOrDefault("$.xgafv")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("1"))
  if valid_589177 != nil:
    section.add "$.xgafv", valid_589177
  var valid_589178 = query.getOrDefault("pageSize")
  valid_589178 = validateParameter(valid_589178, JInt, required = false, default = nil)
  if valid_589178 != nil:
    section.add "pageSize", valid_589178
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
  if body != nil:
    result.add "body", body

proc call*(call_589180: Call_CloudprivatecatalogproducerCatalogsAssociationsList_589163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Association resources under a catalog.
  ## 
  let valid = call_589180.validator(path, query, header, formData, body)
  let scheme = call_589180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589180.url(scheme.get, call_589180.host, call_589180.base,
                         call_589180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589180, url, valid)

proc call*(call_589181: Call_CloudprivatecatalogproducerCatalogsAssociationsList_589163;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsAssociationsList
  ## Lists all Association resources under a catalog.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from the previous call to
  ## `ListAssociations`.
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
  ##         : The resource name of the `Catalog` whose `Associations` are
  ## being retrieved. In the format `catalogs/<catalog>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of catalog associations to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589182 = newJObject()
  var query_589183 = newJObject()
  add(query_589183, "upload_protocol", newJString(uploadProtocol))
  add(query_589183, "fields", newJString(fields))
  add(query_589183, "pageToken", newJString(pageToken))
  add(query_589183, "quotaUser", newJString(quotaUser))
  add(query_589183, "alt", newJString(alt))
  add(query_589183, "oauth_token", newJString(oauthToken))
  add(query_589183, "callback", newJString(callback))
  add(query_589183, "access_token", newJString(accessToken))
  add(query_589183, "uploadType", newJString(uploadType))
  add(path_589182, "parent", newJString(parent))
  add(query_589183, "key", newJString(key))
  add(query_589183, "$.xgafv", newJString(Xgafv))
  add(query_589183, "pageSize", newJInt(pageSize))
  add(query_589183, "prettyPrint", newJBool(prettyPrint))
  result = call_589181.call(path_589182, query_589183, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsAssociationsList* = Call_CloudprivatecatalogproducerCatalogsAssociationsList_589163(
    name: "cloudprivatecatalogproducerCatalogsAssociationsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/associations",
    validator: validate_CloudprivatecatalogproducerCatalogsAssociationsList_589164,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsAssociationsList_589165,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsCreate_589227 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsProductsCreate_589229(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsCreate_589228(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a Product instance under a given Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The catalog name of the new product's parent.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589230 = path.getOrDefault("parent")
  valid_589230 = validateParameter(valid_589230, JString, required = true,
                                 default = nil)
  if valid_589230 != nil:
    section.add "parent", valid_589230
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
  var valid_589231 = query.getOrDefault("upload_protocol")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "upload_protocol", valid_589231
  var valid_589232 = query.getOrDefault("fields")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "fields", valid_589232
  var valid_589233 = query.getOrDefault("quotaUser")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "quotaUser", valid_589233
  var valid_589234 = query.getOrDefault("alt")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = newJString("json"))
  if valid_589234 != nil:
    section.add "alt", valid_589234
  var valid_589235 = query.getOrDefault("oauth_token")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "oauth_token", valid_589235
  var valid_589236 = query.getOrDefault("callback")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "callback", valid_589236
  var valid_589237 = query.getOrDefault("access_token")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "access_token", valid_589237
  var valid_589238 = query.getOrDefault("uploadType")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "uploadType", valid_589238
  var valid_589239 = query.getOrDefault("key")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "key", valid_589239
  var valid_589240 = query.getOrDefault("$.xgafv")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = newJString("1"))
  if valid_589240 != nil:
    section.add "$.xgafv", valid_589240
  var valid_589241 = query.getOrDefault("prettyPrint")
  valid_589241 = validateParameter(valid_589241, JBool, required = false,
                                 default = newJBool(true))
  if valid_589241 != nil:
    section.add "prettyPrint", valid_589241
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

proc call*(call_589243: Call_CloudprivatecatalogproducerCatalogsProductsCreate_589227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Product instance under a given Catalog.
  ## 
  let valid = call_589243.validator(path, query, header, formData, body)
  let scheme = call_589243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589243.url(scheme.get, call_589243.host, call_589243.base,
                         call_589243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589243, url, valid)

proc call*(call_589244: Call_CloudprivatecatalogproducerCatalogsProductsCreate_589227;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsCreate
  ## Creates a Product instance under a given Catalog.
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
  ##         : The catalog name of the new product's parent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589245 = newJObject()
  var query_589246 = newJObject()
  var body_589247 = newJObject()
  add(query_589246, "upload_protocol", newJString(uploadProtocol))
  add(query_589246, "fields", newJString(fields))
  add(query_589246, "quotaUser", newJString(quotaUser))
  add(query_589246, "alt", newJString(alt))
  add(query_589246, "oauth_token", newJString(oauthToken))
  add(query_589246, "callback", newJString(callback))
  add(query_589246, "access_token", newJString(accessToken))
  add(query_589246, "uploadType", newJString(uploadType))
  add(path_589245, "parent", newJString(parent))
  add(query_589246, "key", newJString(key))
  add(query_589246, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589247 = body
  add(query_589246, "prettyPrint", newJBool(prettyPrint))
  result = call_589244.call(path_589245, query_589246, nil, nil, body_589247)

var cloudprivatecatalogproducerCatalogsProductsCreate* = Call_CloudprivatecatalogproducerCatalogsProductsCreate_589227(
    name: "cloudprivatecatalogproducerCatalogsProductsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/products",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsCreate_589228,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsCreate_589229,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsList_589205 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsProductsList_589207(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsList_589206(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589208 = path.getOrDefault("parent")
  valid_589208 = validateParameter(valid_589208, JString, required = true,
                                 default = nil)
  if valid_589208 != nil:
    section.add "parent", valid_589208
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to ListProducts
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of products to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression used to restrict the returned results based
  ## upon properties of the product.
  section = newJObject()
  var valid_589209 = query.getOrDefault("upload_protocol")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "upload_protocol", valid_589209
  var valid_589210 = query.getOrDefault("fields")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "fields", valid_589210
  var valid_589211 = query.getOrDefault("pageToken")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "pageToken", valid_589211
  var valid_589212 = query.getOrDefault("quotaUser")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "quotaUser", valid_589212
  var valid_589213 = query.getOrDefault("alt")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = newJString("json"))
  if valid_589213 != nil:
    section.add "alt", valid_589213
  var valid_589214 = query.getOrDefault("oauth_token")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "oauth_token", valid_589214
  var valid_589215 = query.getOrDefault("callback")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "callback", valid_589215
  var valid_589216 = query.getOrDefault("access_token")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "access_token", valid_589216
  var valid_589217 = query.getOrDefault("uploadType")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "uploadType", valid_589217
  var valid_589218 = query.getOrDefault("key")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "key", valid_589218
  var valid_589219 = query.getOrDefault("$.xgafv")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = newJString("1"))
  if valid_589219 != nil:
    section.add "$.xgafv", valid_589219
  var valid_589220 = query.getOrDefault("pageSize")
  valid_589220 = validateParameter(valid_589220, JInt, required = false, default = nil)
  if valid_589220 != nil:
    section.add "pageSize", valid_589220
  var valid_589221 = query.getOrDefault("prettyPrint")
  valid_589221 = validateParameter(valid_589221, JBool, required = false,
                                 default = newJBool(true))
  if valid_589221 != nil:
    section.add "prettyPrint", valid_589221
  var valid_589222 = query.getOrDefault("filter")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "filter", valid_589222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589223: Call_CloudprivatecatalogproducerCatalogsProductsList_589205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ## 
  let valid = call_589223.validator(path, query, header, formData, body)
  let scheme = call_589223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589223.url(scheme.get, call_589223.host, call_589223.base,
                         call_589223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589223, url, valid)

proc call*(call_589224: Call_CloudprivatecatalogproducerCatalogsProductsList_589205;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsList
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListProducts
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
  ##   parent: string (required)
  ##         : The resource name of the parent resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of products to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression used to restrict the returned results based
  ## upon properties of the product.
  var path_589225 = newJObject()
  var query_589226 = newJObject()
  add(query_589226, "upload_protocol", newJString(uploadProtocol))
  add(query_589226, "fields", newJString(fields))
  add(query_589226, "pageToken", newJString(pageToken))
  add(query_589226, "quotaUser", newJString(quotaUser))
  add(query_589226, "alt", newJString(alt))
  add(query_589226, "oauth_token", newJString(oauthToken))
  add(query_589226, "callback", newJString(callback))
  add(query_589226, "access_token", newJString(accessToken))
  add(query_589226, "uploadType", newJString(uploadType))
  add(path_589225, "parent", newJString(parent))
  add(query_589226, "key", newJString(key))
  add(query_589226, "$.xgafv", newJString(Xgafv))
  add(query_589226, "pageSize", newJInt(pageSize))
  add(query_589226, "prettyPrint", newJBool(prettyPrint))
  add(query_589226, "filter", newJString(filter))
  result = call_589224.call(path_589225, query_589226, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsList* = Call_CloudprivatecatalogproducerCatalogsProductsList_589205(
    name: "cloudprivatecatalogproducerCatalogsProductsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/products",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsList_589206,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsList_589207,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_589269 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_589271(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_589270(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a Version instance under a given Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The product name of the new version's parent.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589272 = path.getOrDefault("parent")
  valid_589272 = validateParameter(valid_589272, JString, required = true,
                                 default = nil)
  if valid_589272 != nil:
    section.add "parent", valid_589272
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
  var valid_589273 = query.getOrDefault("upload_protocol")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "upload_protocol", valid_589273
  var valid_589274 = query.getOrDefault("fields")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "fields", valid_589274
  var valid_589275 = query.getOrDefault("quotaUser")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "quotaUser", valid_589275
  var valid_589276 = query.getOrDefault("alt")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = newJString("json"))
  if valid_589276 != nil:
    section.add "alt", valid_589276
  var valid_589277 = query.getOrDefault("oauth_token")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "oauth_token", valid_589277
  var valid_589278 = query.getOrDefault("callback")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "callback", valid_589278
  var valid_589279 = query.getOrDefault("access_token")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "access_token", valid_589279
  var valid_589280 = query.getOrDefault("uploadType")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "uploadType", valid_589280
  var valid_589281 = query.getOrDefault("key")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "key", valid_589281
  var valid_589282 = query.getOrDefault("$.xgafv")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = newJString("1"))
  if valid_589282 != nil:
    section.add "$.xgafv", valid_589282
  var valid_589283 = query.getOrDefault("prettyPrint")
  valid_589283 = validateParameter(valid_589283, JBool, required = false,
                                 default = newJBool(true))
  if valid_589283 != nil:
    section.add "prettyPrint", valid_589283
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

proc call*(call_589285: Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_589269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Version instance under a given Product.
  ## 
  let valid = call_589285.validator(path, query, header, formData, body)
  let scheme = call_589285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589285.url(scheme.get, call_589285.host, call_589285.base,
                         call_589285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589285, url, valid)

proc call*(call_589286: Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_589269;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsCreate
  ## Creates a Version instance under a given Product.
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
  ##         : The product name of the new version's parent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589287 = newJObject()
  var query_589288 = newJObject()
  var body_589289 = newJObject()
  add(query_589288, "upload_protocol", newJString(uploadProtocol))
  add(query_589288, "fields", newJString(fields))
  add(query_589288, "quotaUser", newJString(quotaUser))
  add(query_589288, "alt", newJString(alt))
  add(query_589288, "oauth_token", newJString(oauthToken))
  add(query_589288, "callback", newJString(callback))
  add(query_589288, "access_token", newJString(accessToken))
  add(query_589288, "uploadType", newJString(uploadType))
  add(path_589287, "parent", newJString(parent))
  add(query_589288, "key", newJString(key))
  add(query_589288, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589289 = body
  add(query_589288, "prettyPrint", newJBool(prettyPrint))
  result = call_589286.call(path_589287, query_589288, nil, nil, body_589289)

var cloudprivatecatalogproducerCatalogsProductsVersionsCreate* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_589269(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/versions", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_589270,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_589271,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_589248 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsList_589250(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsList_589249(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589251 = path.getOrDefault("parent")
  valid_589251 = validateParameter(valid_589251, JString, required = true,
                                 default = nil)
  if valid_589251 != nil:
    section.add "parent", valid_589251
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to ListVersions
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of versions to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589252 = query.getOrDefault("upload_protocol")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "upload_protocol", valid_589252
  var valid_589253 = query.getOrDefault("fields")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "fields", valid_589253
  var valid_589254 = query.getOrDefault("pageToken")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "pageToken", valid_589254
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
  var valid_589263 = query.getOrDefault("pageSize")
  valid_589263 = validateParameter(valid_589263, JInt, required = false, default = nil)
  if valid_589263 != nil:
    section.add "pageSize", valid_589263
  var valid_589264 = query.getOrDefault("prettyPrint")
  valid_589264 = validateParameter(valid_589264, JBool, required = false,
                                 default = newJBool(true))
  if valid_589264 != nil:
    section.add "prettyPrint", valid_589264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589265: Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_589248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ## 
  let valid = call_589265.validator(path, query, header, formData, body)
  let scheme = call_589265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589265.url(scheme.get, call_589265.host, call_589265.base,
                         call_589265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589265, url, valid)

proc call*(call_589266: Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_589248;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsList
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListVersions
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
  ##   parent: string (required)
  ##         : The resource name of the parent resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of versions to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589267 = newJObject()
  var query_589268 = newJObject()
  add(query_589268, "upload_protocol", newJString(uploadProtocol))
  add(query_589268, "fields", newJString(fields))
  add(query_589268, "pageToken", newJString(pageToken))
  add(query_589268, "quotaUser", newJString(quotaUser))
  add(query_589268, "alt", newJString(alt))
  add(query_589268, "oauth_token", newJString(oauthToken))
  add(query_589268, "callback", newJString(callback))
  add(query_589268, "access_token", newJString(accessToken))
  add(query_589268, "uploadType", newJString(uploadType))
  add(path_589267, "parent", newJString(parent))
  add(query_589268, "key", newJString(key))
  add(query_589268, "$.xgafv", newJString(Xgafv))
  add(query_589268, "pageSize", newJInt(pageSize))
  add(query_589268, "prettyPrint", newJBool(prettyPrint))
  result = call_589266.call(path_589267, query_589268, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsVersionsList* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_589248(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/versions", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsList_589249,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsList_589250,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_589290 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsProductsIconsUpload_589292(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "product" in path, "`product` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "product"),
               (kind: ConstantSegment, value: "/icons:upload")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsIconsUpload_589291(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   product: JString (required)
  ##          : The resource name of the product.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `product` field"
  var valid_589293 = path.getOrDefault("product")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = nil)
  if valid_589293 != nil:
    section.add "product", valid_589293
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
  var valid_589294 = query.getOrDefault("upload_protocol")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "upload_protocol", valid_589294
  var valid_589295 = query.getOrDefault("fields")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "fields", valid_589295
  var valid_589296 = query.getOrDefault("quotaUser")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "quotaUser", valid_589296
  var valid_589297 = query.getOrDefault("alt")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("json"))
  if valid_589297 != nil:
    section.add "alt", valid_589297
  var valid_589298 = query.getOrDefault("oauth_token")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "oauth_token", valid_589298
  var valid_589299 = query.getOrDefault("callback")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "callback", valid_589299
  var valid_589300 = query.getOrDefault("access_token")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "access_token", valid_589300
  var valid_589301 = query.getOrDefault("uploadType")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "uploadType", valid_589301
  var valid_589302 = query.getOrDefault("key")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "key", valid_589302
  var valid_589303 = query.getOrDefault("$.xgafv")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = newJString("1"))
  if valid_589303 != nil:
    section.add "$.xgafv", valid_589303
  var valid_589304 = query.getOrDefault("prettyPrint")
  valid_589304 = validateParameter(valid_589304, JBool, required = false,
                                 default = newJBool(true))
  if valid_589304 != nil:
    section.add "prettyPrint", valid_589304
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

proc call*(call_589306: Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_589290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
  ## 
  let valid = call_589306.validator(path, query, header, formData, body)
  let scheme = call_589306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589306.url(scheme.get, call_589306.host, call_589306.base,
                         call_589306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589306, url, valid)

proc call*(call_589307: Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_589290;
          product: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsIconsUpload
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
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
  ##   product: string (required)
  ##          : The resource name of the product.
  var path_589308 = newJObject()
  var query_589309 = newJObject()
  var body_589310 = newJObject()
  add(query_589309, "upload_protocol", newJString(uploadProtocol))
  add(query_589309, "fields", newJString(fields))
  add(query_589309, "quotaUser", newJString(quotaUser))
  add(query_589309, "alt", newJString(alt))
  add(query_589309, "oauth_token", newJString(oauthToken))
  add(query_589309, "callback", newJString(callback))
  add(query_589309, "access_token", newJString(accessToken))
  add(query_589309, "uploadType", newJString(uploadType))
  add(query_589309, "key", newJString(key))
  add(query_589309, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589310 = body
  add(query_589309, "prettyPrint", newJBool(prettyPrint))
  add(path_589308, "product", newJString(product))
  result = call_589307.call(path_589308, query_589309, nil, nil, body_589310)

var cloudprivatecatalogproducerCatalogsProductsIconsUpload* = Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_589290(
    name: "cloudprivatecatalogproducerCatalogsProductsIconsUpload",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{product}/icons:upload",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsIconsUpload_589291,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsIconsUpload_589292,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_589311 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsGetIamPolicy_589313(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsGetIamPolicy_589312(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets IAM policy for the specified Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589314 = path.getOrDefault("resource")
  valid_589314 = validateParameter(valid_589314, JString, required = true,
                                 default = nil)
  if valid_589314 != nil:
    section.add "resource", valid_589314
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589315 = query.getOrDefault("upload_protocol")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "upload_protocol", valid_589315
  var valid_589316 = query.getOrDefault("fields")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "fields", valid_589316
  var valid_589317 = query.getOrDefault("quotaUser")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "quotaUser", valid_589317
  var valid_589318 = query.getOrDefault("alt")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = newJString("json"))
  if valid_589318 != nil:
    section.add "alt", valid_589318
  var valid_589319 = query.getOrDefault("oauth_token")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "oauth_token", valid_589319
  var valid_589320 = query.getOrDefault("callback")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "callback", valid_589320
  var valid_589321 = query.getOrDefault("access_token")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "access_token", valid_589321
  var valid_589322 = query.getOrDefault("uploadType")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "uploadType", valid_589322
  var valid_589323 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589323 = validateParameter(valid_589323, JInt, required = false, default = nil)
  if valid_589323 != nil:
    section.add "options.requestedPolicyVersion", valid_589323
  var valid_589324 = query.getOrDefault("key")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "key", valid_589324
  var valid_589325 = query.getOrDefault("$.xgafv")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = newJString("1"))
  if valid_589325 != nil:
    section.add "$.xgafv", valid_589325
  var valid_589326 = query.getOrDefault("prettyPrint")
  valid_589326 = validateParameter(valid_589326, JBool, required = false,
                                 default = newJBool(true))
  if valid_589326 != nil:
    section.add "prettyPrint", valid_589326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589327: Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_589311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets IAM policy for the specified Catalog.
  ## 
  let valid = call_589327.validator(path, query, header, formData, body)
  let scheme = call_589327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589327.url(scheme.get, call_589327.host, call_589327.base,
                         call_589327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589327, url, valid)

proc call*(call_589328: Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_589311;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsGetIamPolicy
  ## Gets IAM policy for the specified Catalog.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589329 = newJObject()
  var query_589330 = newJObject()
  add(query_589330, "upload_protocol", newJString(uploadProtocol))
  add(query_589330, "fields", newJString(fields))
  add(query_589330, "quotaUser", newJString(quotaUser))
  add(query_589330, "alt", newJString(alt))
  add(query_589330, "oauth_token", newJString(oauthToken))
  add(query_589330, "callback", newJString(callback))
  add(query_589330, "access_token", newJString(accessToken))
  add(query_589330, "uploadType", newJString(uploadType))
  add(query_589330, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589330, "key", newJString(key))
  add(query_589330, "$.xgafv", newJString(Xgafv))
  add(path_589329, "resource", newJString(resource))
  add(query_589330, "prettyPrint", newJBool(prettyPrint))
  result = call_589328.call(path_589329, query_589330, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsGetIamPolicy* = Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_589311(
    name: "cloudprivatecatalogproducerCatalogsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_CloudprivatecatalogproducerCatalogsGetIamPolicy_589312,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsGetIamPolicy_589313,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_589331 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsSetIamPolicy_589333(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsSetIamPolicy_589332(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the IAM policy for the specified Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589334 = path.getOrDefault("resource")
  valid_589334 = validateParameter(valid_589334, JString, required = true,
                                 default = nil)
  if valid_589334 != nil:
    section.add "resource", valid_589334
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
  var valid_589335 = query.getOrDefault("upload_protocol")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "upload_protocol", valid_589335
  var valid_589336 = query.getOrDefault("fields")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "fields", valid_589336
  var valid_589337 = query.getOrDefault("quotaUser")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "quotaUser", valid_589337
  var valid_589338 = query.getOrDefault("alt")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = newJString("json"))
  if valid_589338 != nil:
    section.add "alt", valid_589338
  var valid_589339 = query.getOrDefault("oauth_token")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "oauth_token", valid_589339
  var valid_589340 = query.getOrDefault("callback")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "callback", valid_589340
  var valid_589341 = query.getOrDefault("access_token")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "access_token", valid_589341
  var valid_589342 = query.getOrDefault("uploadType")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "uploadType", valid_589342
  var valid_589343 = query.getOrDefault("key")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "key", valid_589343
  var valid_589344 = query.getOrDefault("$.xgafv")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = newJString("1"))
  if valid_589344 != nil:
    section.add "$.xgafv", valid_589344
  var valid_589345 = query.getOrDefault("prettyPrint")
  valid_589345 = validateParameter(valid_589345, JBool, required = false,
                                 default = newJBool(true))
  if valid_589345 != nil:
    section.add "prettyPrint", valid_589345
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

proc call*(call_589347: Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_589331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM policy for the specified Catalog.
  ## 
  let valid = call_589347.validator(path, query, header, formData, body)
  let scheme = call_589347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589347.url(scheme.get, call_589347.host, call_589347.base,
                         call_589347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589347, url, valid)

proc call*(call_589348: Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_589331;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsSetIamPolicy
  ## Sets the IAM policy for the specified Catalog.
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
  var path_589349 = newJObject()
  var query_589350 = newJObject()
  var body_589351 = newJObject()
  add(query_589350, "upload_protocol", newJString(uploadProtocol))
  add(query_589350, "fields", newJString(fields))
  add(query_589350, "quotaUser", newJString(quotaUser))
  add(query_589350, "alt", newJString(alt))
  add(query_589350, "oauth_token", newJString(oauthToken))
  add(query_589350, "callback", newJString(callback))
  add(query_589350, "access_token", newJString(accessToken))
  add(query_589350, "uploadType", newJString(uploadType))
  add(query_589350, "key", newJString(key))
  add(query_589350, "$.xgafv", newJString(Xgafv))
  add(path_589349, "resource", newJString(resource))
  if body != nil:
    body_589351 = body
  add(query_589350, "prettyPrint", newJBool(prettyPrint))
  result = call_589348.call(path_589349, query_589350, nil, nil, body_589351)

var cloudprivatecatalogproducerCatalogsSetIamPolicy* = Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_589331(
    name: "cloudprivatecatalogproducerCatalogsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_CloudprivatecatalogproducerCatalogsSetIamPolicy_589332,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsSetIamPolicy_589333,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_589352 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogproducerCatalogsTestIamPermissions_589354(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsTestIamPermissions_589353(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Tests the IAM permissions for the specified Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589355 = path.getOrDefault("resource")
  valid_589355 = validateParameter(valid_589355, JString, required = true,
                                 default = nil)
  if valid_589355 != nil:
    section.add "resource", valid_589355
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
  var valid_589356 = query.getOrDefault("upload_protocol")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "upload_protocol", valid_589356
  var valid_589357 = query.getOrDefault("fields")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "fields", valid_589357
  var valid_589358 = query.getOrDefault("quotaUser")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "quotaUser", valid_589358
  var valid_589359 = query.getOrDefault("alt")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = newJString("json"))
  if valid_589359 != nil:
    section.add "alt", valid_589359
  var valid_589360 = query.getOrDefault("oauth_token")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "oauth_token", valid_589360
  var valid_589361 = query.getOrDefault("callback")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "callback", valid_589361
  var valid_589362 = query.getOrDefault("access_token")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "access_token", valid_589362
  var valid_589363 = query.getOrDefault("uploadType")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "uploadType", valid_589363
  var valid_589364 = query.getOrDefault("key")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "key", valid_589364
  var valid_589365 = query.getOrDefault("$.xgafv")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = newJString("1"))
  if valid_589365 != nil:
    section.add "$.xgafv", valid_589365
  var valid_589366 = query.getOrDefault("prettyPrint")
  valid_589366 = validateParameter(valid_589366, JBool, required = false,
                                 default = newJBool(true))
  if valid_589366 != nil:
    section.add "prettyPrint", valid_589366
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

proc call*(call_589368: Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_589352;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the IAM permissions for the specified Catalog.
  ## 
  let valid = call_589368.validator(path, query, header, formData, body)
  let scheme = call_589368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589368.url(scheme.get, call_589368.host, call_589368.base,
                         call_589368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589368, url, valid)

proc call*(call_589369: Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_589352;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsTestIamPermissions
  ## Tests the IAM permissions for the specified Catalog.
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
  var path_589370 = newJObject()
  var query_589371 = newJObject()
  var body_589372 = newJObject()
  add(query_589371, "upload_protocol", newJString(uploadProtocol))
  add(query_589371, "fields", newJString(fields))
  add(query_589371, "quotaUser", newJString(quotaUser))
  add(query_589371, "alt", newJString(alt))
  add(query_589371, "oauth_token", newJString(oauthToken))
  add(query_589371, "callback", newJString(callback))
  add(query_589371, "access_token", newJString(accessToken))
  add(query_589371, "uploadType", newJString(uploadType))
  add(query_589371, "key", newJString(key))
  add(query_589371, "$.xgafv", newJString(Xgafv))
  add(path_589370, "resource", newJString(resource))
  if body != nil:
    body_589372 = body
  add(query_589371, "prettyPrint", newJBool(prettyPrint))
  result = call_589369.call(path_589370, query_589371, nil, nil, body_589372)

var cloudprivatecatalogproducerCatalogsTestIamPermissions* = Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_589352(
    name: "cloudprivatecatalogproducerCatalogsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_CloudprivatecatalogproducerCatalogsTestIamPermissions_589353,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsTestIamPermissions_589354,
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
